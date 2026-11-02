package serviceidentity

import (
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"strings"
)

const (
	PrefixLive = "crk_live_"
	PrefixTest = "crk_test_"
	// KeyEntropyBytes provides 256 bits of cryptographic entropy for API keys.
	KeyEntropyBytes = 32
)

// GenerateRawKey produces a new cryptographically secure random API key string.
// Format: crk_live_<64 hex chars> (total length 73 chars)
func GenerateRawKey(live bool) (plainKey string, keyPrefix string, keyHash string, err error) {
	prefix := PrefixLive
	if !live {
		prefix = PrefixTest
	}

	entropy := make([]byte, KeyEntropyBytes)
	if _, err := rand.Read(entropy); err != nil {
		return "", "", "", fmt.Errorf("serviceidentity: crypto/rand failed: %w", err)
	}

	secretHex := hex.EncodeToString(entropy)
	plainKey = prefix + secretHex
	keyPrefix = ExtractPrefix(plainKey)
	keyHash = HashKey(plainKey)

	return plainKey, keyPrefix, keyHash, nil
}

// HashKey computes the SHA-256 hex digest of the plain API key for secure persistence.
func HashKey(plainKey string) string {
	sum := sha256.Sum256([]byte(plainKey))
	return hex.EncodeToString(sum[:])
}

// ExtractPrefix returns the first 10 characters of the plain key for identification and display.
func ExtractPrefix(plainKey string) string {
	if len(plainKey) <= 10 {
		return plainKey
	}
	return plainKey[:10]
}

// ValidateKeyFormat checks that a candidate token matches the expected Creativanta API key format.
func ValidateKeyFormat(token string) bool {
	if !strings.HasPrefix(token, PrefixLive) && !strings.HasPrefix(token, PrefixTest) {
		return false
	}
	// Expected length: len(crk_live_) + 64 hex chars = 9 + 64 = 73
	if len(token) != 73 {
		return false
	}
	secret := token[9:]
	_, err := hex.DecodeString(secret)
	return err == nil
}
