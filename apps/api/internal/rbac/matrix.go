// Package rbac implements the canonical 7-role Workspace RBAC permission matrix,
// the isolated 8-role Internal Admin RBAC permission matrix, and the 1,188-entry
// RPC permission binding gate from docs/04_contracts/.
//
// Canonical contracts:
//   - docs/04_contracts/rbac_permission_matrix.md
//   - docs/04_contracts/rpc_permission_bindings.csv
//   - docs/02_features/platform/auth.md
//   - docs/02_features/platform/internal_admin.md
package rbac

import (
	"errors"
	"fmt"
	"strings"
)

// AccessDecision represents the matrix cell value in rbac_permission_matrix.md.
type AccessDecision uint8

const (
	AccessDeny AccessDecision = iota
	AccessAllow
	AccessConstrained
)

// Canonical 7 Workspace Roles (rbac_permission_matrix.md §2).
const (
	RoleOwner       = "owner"
	RoleAdmin       = "admin"
	RoleManager     = "manager"
	RoleEditor      = "editor"
	RoleContributor = "contributor"
	RoleViewer      = "viewer"
	RoleExternal    = "external"
)

// Canonical 8 Internal Admin Roles (rbac_permission_matrix.md §3).
const (
	AdminRoleSuper   = "super_admin"
	AdminRoleOps     = "ops_admin"
	AdminRoleFinance = "finance_admin"
	AdminRoleContent = "content_admin"
	AdminRoleSupport = "support_admin"
	AdminRoleTech    = "tech_admin"
	AdminRoleAnalyst = "analyst"
	AdminRoleAuditor = "auditor"
)

var (
	// ErrPermissionDenied indicates the actor role or constraint check denied the action.
	ErrPermissionDenied = errors.New("rbac: permission denied (AUTH_FORBIDDEN_001)")
	// ErrUnknownRole indicates an unrecognized workspace or admin role.
	ErrUnknownRole = errors.New("rbac: unknown role")
	// ErrUnknownPermission indicates an unrecognized or unbound permission key.
	ErrUnknownPermission = errors.New("rbac: unknown permission key")
	// ErrImpersonationReadOnly indicates a mutating action was attempted inside a read-only admin impersonation session.
	ErrImpersonationReadOnly = errors.New("rbac: admin impersonation sessions are strictly read-only for all roles")
	// ErrApprovalRequired indicates an approval-gated action requires an approved policy override.
	ErrApprovalRequired = errors.New("rbac: action requires approval under active workspace policy")
	// ErrAuditReasonRequired indicates a privileged/override action requires a non-empty audit reason.
	ErrAuditReasonRequired = errors.New("rbac: privileged or override action requires non-empty audit reason")
	// ErrTierNotEntitled indicates the workspace subscription tier does not include the requested capability.
	ErrTierNotEntitled = errors.New("rbac: workspace subscription tier does not allow this action")
	// ErrCapabilityUnavailable indicates the platform connector capability is read-only or unavailable.
	ErrCapabilityUnavailable = errors.New("rbac: connector capability unavailable for requested action")
)

var canonicalWorkspaceRoles = []string{
	RoleOwner,
	RoleAdmin,
	RoleManager,
	RoleEditor,
	RoleContributor,
	RoleViewer,
	RoleExternal,
}

var canonicalAdminRoles = []string{
	AdminRoleSuper,
	AdminRoleOps,
	AdminRoleFinance,
	AdminRoleContent,
	AdminRoleSupport,
	AdminRoleTech,
	AdminRoleAnalyst,
	AdminRoleAuditor,
}

// IsValidWorkspaceRole reports whether role is one of the 7 canonical workspace roles.
func IsValidWorkspaceRole(role string) bool {
	for _, r := range canonicalWorkspaceRoles {
		if r == role {
			return true
		}
	}
	return false
}

// IsValidAdminRole reports whether role is one of the 8 canonical internal admin roles.
func IsValidAdminRole(role string) bool {
	for _, r := range canonicalAdminRoles {
		if r == role {
			return true
		}
	}
	return false
}

// CanonicalWorkspaceRoles returns a copy of the 7 canonical workspace roles in hierarchy order.
func CanonicalWorkspaceRoles() []string {
	out := make([]string, len(canonicalWorkspaceRoles))
	copy(out, canonicalWorkspaceRoles)
	return out
}

// CanonicalAdminRoles returns a copy of the 8 canonical internal admin roles.
func CanonicalAdminRoles() []string {
	out := make([]string, len(canonicalAdminRoles))
	copy(out, canonicalAdminRoles)
	return out
}

type workspaceMatrixRow [7]AccessDecision
type adminMatrixRow [8]AccessDecision

var workspaceRoleIndex = map[string]int{
	RoleOwner:       0,
	RoleAdmin:       1,
	RoleManager:     2,
	RoleEditor:      3,
	RoleContributor: 4,
	RoleViewer:      5,
	RoleExternal:    6,
}

var adminRoleIndex = map[string]int{
	AdminRoleSuper:   0,
	AdminRoleOps:     1,
	AdminRoleFinance: 2,
	AdminRoleContent: 3,
	AdminRoleSupport: 4,
	AdminRoleTech:    5,
	AdminRoleAnalyst: 6,
	AdminRoleAuditor: 7,
}

// workspacePermissionMatrix encodes §2.1–§2.16 of docs/04_contracts/rbac_permission_matrix.md verbatim.
var workspacePermissionMatrix = map[string]workspaceMatrixRow{
	"workspace:settings:manage":    {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"workspace:members:invite":     {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"workspace:members:remove":     {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"workspace:roles:assign":       {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"workspace:billing:manage":     {AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"workspace:billing:read":       {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"workspace:delete":             {AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"account:connect":              {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"account:disconnect":           {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"trend:read":                   {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"trend:watchlist:manage":       {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"competitor:manage":            {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"competitor:read":              {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"opportunity:read":             {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"opportunity:create":           {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"opportunity:assign":           {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"opportunity:convert":          {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"idea:read":                    {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessConstrained},
	"idea:create":                  {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"idea:convert":                 {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"script:read":                  {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessConstrained},
	"script:create":                {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"script:edit":                  {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessConstrained, AccessDeny, AccessDeny},
	"script:approve":               {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"script:delete":                {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"asset:read":                   {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessConstrained},
	"asset:generate":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessConstrained, AccessDeny, AccessDeny},
	"asset:approve":                {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"asset:promote_canonical":      {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"asset:delete":                 {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"character:manage":             {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"continuity:pack_manage":       {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"derivative:manage":            {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"voice_clone:read":             {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"voice_clone:manage":           {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"voice_clone:delete":           {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"sound:read":                   {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"sound:generate":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"production_job:read":          {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"production_job:manage":        {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"style_pack:read":              {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"style_pack:manage":            {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"style_pack:delete":            {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"translation:read":             {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"translation:manage":           {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"repurpose:read":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"repurpose:manage":             {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"publish:read":                 {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"publish:create":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"publish:schedule":             {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"publish:execute":              {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"publish:approve":              {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"publish:retry":                {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"publish:cancel":               {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"packaging:read":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"packaging:score":              {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"packaging:override":           {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"thread:read":                  {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"thread:triage":                {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"thread:reply":                 {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"thread:assign":                {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"follow_up:manage":             {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"product:read":                 {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"product:manage":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"product:delete":               {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"product:import":               {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"offer:read":                   {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"offer:manage":                 {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"offer:activate":               {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"order:read":                   {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"order:manage":                 {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"campaign:read":                {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"campaign:manage":              {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"coupon:read":                  {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"coupon:manage":                {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"affiliate:read":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"affiliate:manage":             {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"store:manage":                 {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"membership:read":              {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"membership:manage":            {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"offer:price_change":           {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"refund:read":                  {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"refund:manage":                {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"showcase:read":                {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"showcase:manage":              {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"link_to_video:read":           {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"link_to_video:manage":         {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"ab_test:read":                 {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"ab_test:manage":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"ab_test:declare_winner":       {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"profit:read":                  {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"profit:detailed_read":         {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"cost:manage":                  {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"settlement:import":            {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"reconciliation:manage":        {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"reconciliation:override":      {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"evidence:submit":              {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"evidence:read":                {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"proof_bundle:read":            {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"workflow:read":                {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"workflow:create":              {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"workflow:edit":                {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"workflow:activate":            {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"workflow_run:approve":         {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"recipe:install":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"agent:execute":                {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"agent:approve":                {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"report:read":                  {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"report:export":                {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"diagnostics:read":             {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"admin:audit_log:read":         {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"admin:override":               {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"capability:read":              {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"live:read":                    {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"live:manage":                  {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"live:start_stop":              {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"live:cue_action":              {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"live:highlight":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"sample:read":                  {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"sample:manage":                {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"creator_assignment:manage":    {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"link_in_bio:read":             {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"link_in_bio:manage":           {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"media_kit:read":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessConstrained},
	"media_kit:generate":           {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"media_kit:publish":            {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"rate_card:read":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"rate_card:manage":             {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"brand_deal:read":              {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"brand_deal:manage":            {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"gamification:read":            {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"gamification:share":           {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"referral:read":                {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"referral:claim":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"promotion:read":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"promotion:redeem":             {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"coach:read":                   {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"coach:generate_plan":          {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"copilot:use_creative":         {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"copilot:use_analytics":        {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"copilot:use_action":           {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"copilot:use_video_production": {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"copilot:use_help":             {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"credits:view_balance":         {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"credits:top_up":               {AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"user:self":                    {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow},
	"workspace:read":               {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"account:read":                 {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"file:read":                    {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"file:manage":                  {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny},
	"entity:read":                  {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"entity:manage":                {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"task:read":                    {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"task:manage":                  {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"store:read":                   {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessDeny},
	"cost:read":                    {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"settlement:read":              {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"reconciliation:read":          {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"proof_bundle:assemble":        {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"api_key:manage":               {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"support:own":                  {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow},
}

// adminPermissionMatrix encodes §3.2–§3.3 of docs/04_contracts/rbac_permission_matrix.md verbatim.
var adminPermissionMatrix = map[string]adminMatrixRow{
	"admin:user:suspend":         {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"admin:user:delete":          {AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"admin:credits:adjust":       {AccessAllow, AccessDeny, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"admin:plan:override":        {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"admin:refund:issue":         {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"admin:impersonate":          {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessConstrained, AccessDeny, AccessDeny, AccessDeny},
	"admin:moderation:manage":    {AccessAllow, AccessDeny, AccessDeny, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"admin:fraud:investigate":    {AccessAllow, AccessDeny, AccessDeny, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"admin:support:manage":       {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"admin:incident:manage":      {AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessAllow, AccessDeny, AccessDeny},
	"admin:feature_flag:toggle":  {AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessAllow, AccessDeny, AccessDeny},
	"admin:announcement:publish": {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"admin:maintenance:toggle":   {AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessAllow, AccessDeny, AccessDeny},
	"admin:queue:manage":         {AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessAllow, AccessDeny, AccessDeny},
	"admin:audit_log:read":       {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessConstrained, AccessAllow, AccessAllow, AccessAllow},
	"admin:analytics:read":       {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessAllow, AccessAllow, AccessAllow},
	"admin:billing:read":         {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessConstrained, AccessDeny, AccessAllow, AccessAllow},
	"admin:fee_schedule:manage":  {AccessAllow, AccessDeny, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"admin:report:export":        {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessAllow, AccessAllow, AccessAllow},
	"admin:compliance:read":      {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessAllow},
	"admin:user:read":            {AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow, AccessAllow},
	"admin:workspace:read":       {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessAllow, AccessAllow, AccessAllow, AccessAllow},
	"admin:commerce:read":        {AccessAllow, AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessAllow, AccessDeny},
	"admin:config:manage":        {AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessAllow, AccessDeny, AccessDeny},
	"admin:users:manage":         {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessAllow, AccessDeny, AccessDeny, AccessDeny},
	"admin:admins:manage":        {AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessDeny},
	"admin:ai:manage":            {AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessDeny, AccessAllow, AccessDeny, AccessDeny},
	"admin:alerts:manage":        {AccessAllow, AccessAllow, AccessDeny, AccessDeny, AccessDeny, AccessAllow, AccessDeny, AccessDeny},
}

// WorkspacePermissionCount returns the number of canonical workspace permissions in the matrix.
func WorkspacePermissionCount() int {
	return len(workspacePermissionMatrix)
}

// AdminPermissionCount returns the number of canonical internal admin permissions in the matrix.
func AdminPermissionCount() int {
	return len(adminPermissionMatrix)
}

// LookupWorkspaceDecision returns the raw matrix cell (AccessAllow, AccessConstrained, AccessDeny)
// for a workspace role and permission key.
func LookupWorkspaceDecision(role, permissionKey string) (AccessDecision, error) {
	idx, ok := workspaceRoleIndex[role]
	if !ok {
		return AccessDeny, fmt.Errorf("%w: %q", ErrUnknownRole, role)
	}
	row, ok := workspacePermissionMatrix[permissionKey]
	if !ok {
		return AccessDeny, fmt.Errorf("%w: %q", ErrUnknownPermission, permissionKey)
	}
	return row[idx], nil
}

// LookupAdminDecision returns the raw matrix cell (AccessAllow, AccessConstrained, AccessDeny)
// for an internal admin role and admin permission key.
func LookupAdminDecision(adminRole, permissionKey string) (AccessDecision, error) {
	idx, ok := adminRoleIndex[adminRole]
	if !ok {
		return AccessDeny, fmt.Errorf("%w: %q", ErrUnknownRole, adminRole)
	}
	row, ok := adminPermissionMatrix[permissionKey]
	if !ok {
		return AccessDeny, fmt.Errorf("%w: %q", ErrUnknownPermission, permissionKey)
	}
	return row[idx], nil
}

// PolicyContext supplies object-level, tier, approval, and capability facts required
// to evaluate constrained permissions and RPC bindings (§4 & §5 of rbac_permission_matrix.md).
type PolicyContext struct {
	ActorUserID                string
	TargetOwnerUserID          string
	WorkspaceID                string
	Role                       string
	AdminRole                  string
	IsImpersonation            bool
	ObjectSharedExternally     bool
	IsObjectAuthor             bool
	WithinContributorQuota     bool
	ApprovalPolicyActive       bool
	ApprovalGranted            bool
	AuditReason                string
	TierEntitled               *bool
	ConnectorCapabilityAllowed *bool
	SupportScopedReadAllowed   bool
}

var approvalRequiredPermissions = map[string]bool{
	"publish:execute":         true,
	"offer:price_change":      true,
	"reconciliation:override": true,
	"workflow:activate":       true,
}

// CheckWorkspacePermission evaluates both the 7-role matrix cell and all §4 constraint rules.
func CheckWorkspacePermission(permissionKey string, pctx PolicyContext) error {
	if pctx.IsImpersonation {
		// Impersonation is read-only for every admin role.
		if !strings.HasSuffix(permissionKey, ":read") && permissionKey != "credits:view_balance" && permissionKey != "user:self" {
			return ErrImpersonationReadOnly
		}
	}

	decision, err := LookupWorkspaceDecision(pctx.Role, permissionKey)
	if err != nil {
		return err
	}
	if decision == AccessDeny {
		return fmt.Errorf("%w: role %q lacks %q", ErrPermissionDenied, pctx.Role, permissionKey)
	}

	// user:self and support:own never grant access to another user resource (§2.16).
	if (permissionKey == "user:self" || permissionKey == "support:own") &&
		pctx.TargetOwnerUserID != "" && pctx.ActorUserID != "" && pctx.ActorUserID != pctx.TargetOwnerUserID {
		return fmt.Errorf("%w: %s cannot access another user resource", ErrPermissionDenied, permissionKey)
	}

	// Constrained cell rules (§4).
	if decision == AccessConstrained {
		switch pctx.Role {
		case RoleExternal:
			if !pctx.ObjectSharedExternally {
				return fmt.Errorf("%w: external collaborator requires explicit share/assignment for %s", ErrPermissionDenied, permissionKey)
			}
		case RoleContributor:
			if permissionKey == "script:edit" && !pctx.IsObjectAuthor {
				return fmt.Errorf("%w: contributor may only edit own scripts", ErrPermissionDenied)
			}
			if permissionKey == "asset:generate" && !pctx.WithinContributorQuota {
				return fmt.Errorf("%w: contributor daily generation credit quota exceeded", ErrPermissionDenied)
			}
		default:
			return fmt.Errorf("%w: unsatisfied constraint for role %q on %s", ErrPermissionDenied, pctx.Role, permissionKey)
		}
	}

	// Approval-Required Actions (§4).
	if approvalRequiredPermissions[permissionKey] && pctx.ApprovalPolicyActive && !pctx.ApprovalGranted {
		return fmt.Errorf("%w: %s", ErrApprovalRequired, permissionKey)
	}
	if permissionKey == "admin:override" && strings.TrimSpace(pctx.AuditReason) == "" {
		return ErrAuditReasonRequired
	}

	if pctx.TierEntitled != nil && !*pctx.TierEntitled {
		return ErrTierNotEntitled
	}
	if pctx.ConnectorCapabilityAllowed != nil && !*pctx.ConnectorCapabilityAllowed {
		return ErrCapabilityUnavailable
	}

	return nil
}

// CheckAdminPermission evaluates the isolated 8-role Internal Admin RBAC matrix and constraints.
// Note: Workspace roles are never accepted here; internal admin identity is a separate trust boundary.
func CheckAdminPermission(permissionKey string, pctx PolicyContext, isMutating bool) error {
	if pctx.IsImpersonation && isMutating {
		return ErrImpersonationReadOnly
	}
	// Reject any workspace role passed as adminRole.
	if !IsValidAdminRole(pctx.AdminRole) {
		return fmt.Errorf("%w: %q is not an internal admin role", ErrUnknownRole, pctx.AdminRole)
	}
	// Analyst and Auditor are strictly read-only roles (§3.2).
	if (pctx.AdminRole == AdminRoleAnalyst || pctx.AdminRole == AdminRoleAuditor) && isMutating {
		return fmt.Errorf("%w: role %q is read-only", ErrPermissionDenied, pctx.AdminRole)
	}

	decision, err := LookupAdminDecision(pctx.AdminRole, permissionKey)
	if err != nil {
		return err
	}
	if decision == AccessDeny {
		return fmt.Errorf("%w: admin role %q lacks %q", ErrPermissionDenied, pctx.AdminRole, permissionKey)
	}
	if decision == AccessConstrained {
		if pctx.AdminRole == AdminRoleSupport {
			if permissionKey == "admin:impersonate" && isMutating {
				return ErrImpersonationReadOnly
			}
			if (permissionKey == "admin:audit_log:read" || permissionKey == "admin:billing:read") && !pctx.SupportScopedReadAllowed {
				return fmt.Errorf("%w: support_admin requires scoped ticket/ReadOnly context for %s", ErrPermissionDenied, permissionKey)
			}
		}
	}
	if isMutating && strings.TrimSpace(pctx.AuditReason) == "" {
		return ErrAuditReasonRequired
	}
	return nil
}
