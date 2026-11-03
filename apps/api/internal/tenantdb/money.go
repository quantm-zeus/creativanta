// Package tenantdb enforces Creativanta's PostgreSQL tenant transaction boundary
// (WithTx + SET LOCAL app.current_tenant_id / app.current_user_id) and exact
// base-10 decimal money/credit arithmetic without floating-point conversions.
//
// Canonical contract: docs/04_contracts/database_schema.md (§1, §2, §4.1, §26.11–§26.14)
// Blocker reference: DB-H-001 (NEVER use REAL or FLOAT for money/credit fields)
package tenantdb

import (
	"encoding/json"
	"errors"
	"fmt"
	"math/big"
	"regexp"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
)

const (
	// MaxDecimalPrecision is the canonical NUMERIC(18,6) total digit precision.
	MaxDecimalPrecision = 18
	// MaxDecimalScale is the canonical NUMERIC(18,6) fractional digit scale.
	MaxDecimalScale = 6
)

var (
	// ErrFloatForbidden is returned whenever a caller attempts to convert float32/float64 to/from money or credits.
	ErrFloatForbidden = errors.New("tenantdb: floating-point representation is strictly forbidden for money/credit fields (DB-H-001)")
	// ErrInvalidDecimal is returned when a decimal string violates NUMERIC(18,6) canonical rules.
	ErrInvalidDecimal = errors.New("tenantdb: invalid canonical base-10 decimal string for NUMERIC(18,6)")
	// ErrInvalidCurrency is returned when an ISO 4217 currency code is invalid.
	ErrInvalidCurrency = errors.New("tenantdb: currency must be a 3-letter uppercase ISO 4217 code")
	// ErrCurrencyMismatch is returned when arithmetic is attempted across different currencies.
	ErrCurrencyMismatch = errors.New("tenantdb: currency mismatch in monetary arithmetic")
)

var (
	canonicalDecimalPattern = regexp.MustCompile(`^-?(?:0|[1-9][0-9]*)(?:\.[0-9]+)?$`)
	isoCurrencyPattern      = regexp.MustCompile(`^[A-Z]{3}$`)
	tenPow6                 = big.NewInt(1_000_000)
)

// ExactDecimal represents an exact fixed-point NUMERIC(18,6) value stored as
// an integer scaled by 10^6 (micro-units). It never touches float32 or float64.
type ExactDecimal struct {
	micros *big.Int
}

// ZeroDecimal returns an ExactDecimal equal to 0.
func ZeroDecimal() ExactDecimal {
	return ExactDecimal{micros: big.NewInt(0)}
}

// ParseExactDecimal parses a canonical base-10 decimal string into an ExactDecimal
// with precision <= 18 and scale <= 6, rejecting exponent notation, NaN, Inf, and whitespace.
func ParseExactDecimal(raw string) (ExactDecimal, error) {
	if raw == "" || strings.TrimSpace(raw) != raw {
		return ExactDecimal{}, fmt.Errorf("%w: %q", ErrInvalidDecimal, raw)
	}
	if !canonicalDecimalPattern.MatchString(raw) {
		return ExactDecimal{}, fmt.Errorf("%w: %q", ErrInvalidDecimal, raw)
	}

	negative := false
	unsigned := raw
	if strings.HasPrefix(unsigned, "-") {
		negative = true
		unsigned = unsigned[1:]
	}

	parts := strings.Split(unsigned, ".")
	intPart := parts[0]
	fracPart := ""
	if len(parts) == 2 {
		fracPart = parts[1]
	}

	if len(fracPart) > MaxDecimalScale {
		return ExactDecimal{}, fmt.Errorf("%w: scale %d exceeds max %d in %q", ErrInvalidDecimal, len(fracPart), MaxDecimalScale, raw)
	}
	// In NUMERIC(18,6), integer digits cannot exceed 18 - 6 = 12 significant digits.
	sigIntDigits := len(strings.TrimLeft(intPart, "0"))
	if sigIntDigits > (MaxDecimalPrecision - MaxDecimalScale) {
		return ExactDecimal{}, fmt.Errorf("%w: integer digits %d exceed max %d in %q", ErrInvalidDecimal, sigIntDigits, MaxDecimalPrecision-MaxDecimalScale, raw)
	}
	totalDigits := sigIntDigits + len(fracPart)
	if totalDigits > MaxDecimalPrecision {
		return ExactDecimal{}, fmt.Errorf("%w: precision %d exceeds max %d in %q", ErrInvalidDecimal, totalDigits, MaxDecimalPrecision, raw)
	}

	paddedFrac := fracPart + strings.Repeat("0", MaxDecimalScale-len(fracPart))
	combined := intPart + paddedFrac
	micros, ok := new(big.Int).SetString(combined, 10)
	if !ok {
		return ExactDecimal{}, fmt.Errorf("%w: %q", ErrInvalidDecimal, raw)
	}
	if negative && micros.Sign() != 0 {
		micros.Neg(micros)
	}
	return ExactDecimal{micros: micros}, nil
}

// RejectFloatInput fails closed if v is float32 or float64, and otherwise parses string or ExactDecimal.
func RejectFloatInput(v any) (ExactDecimal, error) {
	switch val := v.(type) {
	case float32, float64, *float32, *float64:
		return ExactDecimal{}, ErrFloatForbidden
	case ExactDecimal:
		return val, nil
	case string:
		return ParseExactDecimal(val)
	case pgtype.Numeric:
		return FromPgNumeric(val)
	default:
		return ExactDecimal{}, fmt.Errorf("%w: unsupported type %T", ErrInvalidDecimal, v)
	}
}

// ToPgNumeric converts ExactDecimal to pgx's exact integer+exponent pgtype.Numeric.
func (d ExactDecimal) ToPgNumeric() pgtype.Numeric {
	m := new(big.Int)
	if d.micros != nil {
		m.Set(d.micros)
	}
	return pgtype.Numeric{
		Int:   m,
		Exp:   -MaxDecimalScale,
		Valid: true,
	}
}

// FromPgNumeric converts a pgtype.Numeric to ExactDecimal without floating-point intermediates.
func FromPgNumeric(num pgtype.Numeric) (ExactDecimal, error) {
	if !num.Valid || num.NaN || num.InfinityModifier != pgtype.Finite || num.Int == nil {
		return ExactDecimal{}, fmt.Errorf("%w: non-finite or NULL pgtype.Numeric", ErrInvalidDecimal)
	}

	scaled := new(big.Int).Set(num.Int)
	shift := int(num.Exp) + MaxDecimalScale
	if shift > 0 {
		factor := new(big.Int).Exp(big.NewInt(10), big.NewInt(int64(shift)), nil)
		scaled.Mul(scaled, factor)
	} else if shift < 0 {
		divisor := new(big.Int).Exp(big.NewInt(10), big.NewInt(int64(-shift)), nil)
		quo, rem := new(big.Int).QuoRem(scaled, divisor, new(big.Int))
		if rem.Sign() != 0 {
			return ExactDecimal{}, fmt.Errorf("%w: pgtype.Numeric has scale exceeding %d", ErrInvalidDecimal, MaxDecimalScale)
		}
		scaled = quo
	}

	// Verify bounds: abs(scaled) < 10^18
	maxMicros := new(big.Int).Exp(big.NewInt(10), big.NewInt(MaxDecimalPrecision), nil)
	absScaled := new(big.Int).Abs(scaled)
	if absScaled.Cmp(maxMicros) >= 0 {
		return ExactDecimal{}, fmt.Errorf("%w: pgtype.Numeric exceeds NUMERIC(18,6) precision", ErrInvalidDecimal)
	}

	return ExactDecimal{micros: scaled}, nil
}

// String formats ExactDecimal as a canonical base-10 string without trailing fractional zeros
// (or "0" when zero), suitable for commonv1.Money.Amount.
func (d ExactDecimal) String() string {
	if d.micros == nil || d.micros.Sign() == 0 {
		return "0"
	}
	neg := d.micros.Sign() < 0
	abs := new(big.Int).Abs(d.micros)
	intPart, fracInt := new(big.Int).QuoRem(abs, tenPow6, new(big.Int))

	signPrefix := ""
	if neg {
		signPrefix = "-"
	}
	if fracInt.Sign() == 0 {
		return signPrefix + intPart.String()
	}
	fracStr := fmt.Sprintf("%06s", fracInt.String())
	fracStr = strings.TrimRight(fracStr, "0")
	return signPrefix + intPart.String() + "." + fracStr
}

// Fixed6String formats ExactDecimal with all 6 fractional digits (e.g., "125000.500000").
func (d ExactDecimal) Fixed6String() string {
	if d.micros == nil || d.micros.Sign() == 0 {
		return "0.000000"
	}
	neg := d.micros.Sign() < 0
	abs := new(big.Int).Abs(d.micros)
	intPart, fracInt := new(big.Int).QuoRem(abs, tenPow6, new(big.Int))
	signPrefix := ""
	if neg {
		signPrefix = "-"
	}
	return fmt.Sprintf("%s%s.%06s", signPrefix, intPart.String(), fracInt.String())
}

// Add returns d + other, failing if the result overflows NUMERIC(18,6).
func (d ExactDecimal) Add(other ExactDecimal) (ExactDecimal, error) {
	a := big.NewInt(0)
	if d.micros != nil {
		a.Set(d.micros)
	}
	b := big.NewInt(0)
	if other.micros != nil {
		b.Set(other.micros)
	}
	sum := new(big.Int).Add(a, b)
	return FromPgNumeric(pgtype.Numeric{Int: sum, Exp: -MaxDecimalScale, Valid: true})
}

// Sub returns d - other, failing if the result overflows NUMERIC(18,6).
func (d ExactDecimal) Sub(other ExactDecimal) (ExactDecimal, error) {
	a := big.NewInt(0)
	if d.micros != nil {
		a.Set(d.micros)
	}
	b := big.NewInt(0)
	if other.micros != nil {
		b.Set(other.micros)
	}
	diff := new(big.Int).Sub(a, b)
	return FromPgNumeric(pgtype.Numeric{Int: diff, Exp: -MaxDecimalScale, Valid: true})
}

// Cmp compares d and other (-1 if d < other, 0 if d == other, +1 if d > other).
func (d ExactDecimal) Cmp(other ExactDecimal) int {
	a := big.NewInt(0)
	if d.micros != nil {
		a.Set(d.micros)
	}
	b := big.NewInt(0)
	if other.micros != nil {
		b.Set(other.micros)
	}
	return a.Cmp(b)
}

// IsNegative reports whether d < 0.
func (d ExactDecimal) IsNegative() bool {
	return d.micros != nil && d.micros.Sign() < 0
}

// IsPositive reports whether d > 0.
func (d ExactDecimal) IsPositive() bool {
	return d.micros != nil && d.micros.Sign() > 0
}

// IsZero reports whether d == 0.
func (d ExactDecimal) IsZero() bool {
	return d.micros == nil || d.micros.Sign() == 0
}

// MustParseExactDecimal parses raw or panics if raw is not a valid canonical decimal string.
func MustParseExactDecimal(raw string) ExactDecimal {
	dec, err := ParseExactDecimal(raw)
	if err != nil {
		panic(err)
	}
	return dec
}

// MulFloor multiplies two non-negative ExactDecimals and truncates any sub-micro remainder toward zero.
func (d ExactDecimal) MulFloor(other ExactDecimal) (ExactDecimal, error) {
	a := big.NewInt(0)
	if d.micros != nil {
		a.Set(d.micros)
	}
	b := big.NewInt(0)
	if other.micros != nil {
		b.Set(other.micros)
	}
	prod := new(big.Int).Mul(a, b)
	scaled := new(big.Int).Quo(prod, tenPow6)
	return FromPgNumeric(pgtype.Numeric{Int: scaled, Exp: -MaxDecimalScale, Valid: true})
}

// CeilWhole rounds a positive ExactDecimal up to the smallest whole integer >= d.
func (d ExactDecimal) CeilWhole() (ExactDecimal, error) {
	a := big.NewInt(0)
	if d.micros != nil {
		a.Set(d.micros)
	}
	if a.Sign() <= 0 {
		return ExactDecimal{micros: a}, nil
	}
	whole, rem := new(big.Int).QuoRem(a, tenPow6, new(big.Int))
	if rem.Sign() > 0 {
		whole.Add(whole, big.NewInt(1))
	}
	scaled := new(big.Int).Mul(whole, tenPow6)
	return FromPgNumeric(pgtype.Numeric{Int: scaled, Exp: -MaxDecimalScale, Valid: true})
}

// ComputeQuotedCredits computes the canonical cost-based credit quote ceiling using
// exact integer big.Int arithmetic (NEVER float):
//
//	quoted_credits = ceil(cost_ceiling_usd / (usd_per_credit_floor * (1 - gross_margin_floor)))
//
// Reference: docs/01_business/pricing_and_credits.md §3.0 & docs/04_contracts/credit_accounting_contract.md §2.
func ComputeQuotedCredits(costCeilingUSD, usdPerCreditFloor, grossMarginFloor ExactDecimal) (ExactDecimal, error) {
	costMicros := big.NewInt(0)
	if costCeilingUSD.micros != nil {
		costMicros.Set(costCeilingUSD.micros)
	}
	if costMicros.Sign() <= 0 {
		return ExactDecimal{}, fmt.Errorf("%w: cost_ceiling_usd must be > 0", ErrInvalidDecimal)
	}

	floorMicros := big.NewInt(0)
	if usdPerCreditFloor.micros != nil {
		floorMicros.Set(usdPerCreditFloor.micros)
	}
	if floorMicros.Sign() <= 0 {
		return ExactDecimal{}, fmt.Errorf("%w: usd_per_credit_floor must be > 0", ErrInvalidDecimal)
	}

	marginMicros := big.NewInt(0)
	if grossMarginFloor.micros != nil {
		marginMicros.Set(grossMarginFloor.micros)
	}
	if marginMicros.Sign() < 0 || marginMicros.Cmp(tenPow6) >= 0 {
		return ExactDecimal{}, fmt.Errorf("%w: gross_margin_floor must be in [0, 1)", ErrInvalidDecimal)
	}

	// oneMinusMarginMicros = 1_000_000 - marginMicros
	oneMinusMarginMicros := new(big.Int).Sub(tenPow6, marginMicros)
	// denom (scale 10^12) = floorMicros * oneMinusMarginMicros
	denom := new(big.Int).Mul(floorMicros, oneMinusMarginMicros)
	// num (scale 10^12) = costMicros * 1_000_000
	num := new(big.Int).Mul(costMicros, tenPow6)

	// ceilWholeCredits = (num + denom - 1) / denom
	numPlus := new(big.Int).Add(num, denom)
	numPlus.Sub(numPlus, big.NewInt(1))
	wholeCredits := new(big.Int).Quo(numPlus, denom)
	if wholeCredits.Sign() <= 0 {
		wholeCredits.SetInt64(1)
	}

	scaledCredits := new(big.Int).Mul(wholeCredits, tenPow6)
	return FromPgNumeric(pgtype.Numeric{Int: scaledCredits, Exp: -MaxDecimalScale, Valid: true})
}

// ToProtoMoney converts ExactDecimal and an ISO 4217 currency into a validated commonv1.Money.
func (d ExactDecimal) ToProtoMoney(currency string, allowNegative bool) (*commonv1.Money, error) {
	if !isoCurrencyPattern.MatchString(currency) {
		return nil, fmt.Errorf("%w: %q", ErrInvalidCurrency, currency)
	}
	if !allowNegative && d.IsNegative() {
		return nil, fmt.Errorf("%w: negative amount %s not permitted", ErrInvalidDecimal, d.String())
	}
	return &commonv1.Money{
		Amount:   d.String(),
		Currency: currency,
	}, nil
}

// FromProtoMoney validates a commonv1.Money message and extracts its ExactDecimal and currency.
func FromProtoMoney(m *commonv1.Money, allowNegative bool) (ExactDecimal, string, error) {
	if m == nil {
		return ExactDecimal{}, "", fmt.Errorf("%w: nil Money message", ErrInvalidDecimal)
	}
	if !isoCurrencyPattern.MatchString(m.GetCurrency()) {
		return ExactDecimal{}, "", fmt.Errorf("%w: %q", ErrInvalidCurrency, m.GetCurrency())
	}
	dec, err := ParseExactDecimal(m.GetAmount())
	if err != nil {
		return ExactDecimal{}, "", err
	}
	if !allowNegative && dec.IsNegative() {
		return ExactDecimal{}, "", fmt.Errorf("%w: negative amount %s not permitted", ErrInvalidDecimal, m.GetAmount())
	}
	return dec, m.GetCurrency(), nil
}

// MarshalJSON serializes ExactDecimal as a canonical base-10 decimal string (never a JSON number/float).
func (d ExactDecimal) MarshalJSON() ([]byte, error) {
	return json.Marshal(d.String())
}

// UnmarshalJSON parses a canonical base-10 decimal string into ExactDecimal, rejecting JSON numbers/floats.
func (d *ExactDecimal) UnmarshalJSON(data []byte) error {
	trimmed := strings.TrimSpace(string(data))
	if trimmed == "null" {
		d.micros = big.NewInt(0)
		return nil
	}
	var raw string
	if err := json.Unmarshal(data, &raw); err != nil {
		return fmt.Errorf("%w: JSON money/credit must be a quoted decimal string, got %s", ErrFloatForbidden, trimmed)
	}
	parsed, err := ParseExactDecimal(raw)
	if err != nil {
		return err
	}
	d.micros = parsed.micros
	return nil
}
