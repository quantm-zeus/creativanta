---
layer: contracts
canonical: false
created: 2026-04-01
updated: 2026-04-09
status: HISTORICAL_TRACEABILITY
---

# Screen→API Reconciliation Matrix

> **Status**: Historical traceability record only.
> This file may still contain legacy screen RPC references captured during reconciliation work. It is **not** the canonical API source and it is **not** proof that every screen doc is implementation-clean.
> Canonical API truth lives in `api_endpoint_map.md`; current readiness/blockers live in `00_index/OPEN_BLOCKERS.md`.

## Summary

| Metric | Count | Note |
|--------|-------|------|
| Total unique screen API refs | **~907** | Extracted from screen doc action tables |
| Concrete RPCs in API map | **~1,160** | Per `api_endpoint_map.md` as of 2026-04-06 (§2-§20) |
| Screen refs matching API map | **907 / 907** | **100% inventory coverage** — all screen RPC references map to canonical API definitions |
| Screen refs with no API map entry | **0** | Previously ~572; fully closed |
| Gap: screen refs without concrete RPC definition | **0** | ✅ Fully resolved |
| Affected screen files | **0 / 243** | No screens reference undefined RPCs |
| Services in screens | **~133** | All services now have canonical RPC definitions |
| Services with full RPC-level definitions | **~133** | All 133 services fully defined |

> ✅ **All screen-referenced RPCs now have canonical definitions** in `api_endpoint_map.md` with method, auth level, rate limit, and description.
>
> This is an inventory-traceability statement only. It does **not** mean every screen is behaviorally perfect without checking feature/spec/schema/RBAC layers.


---

## 1. Covered RPCs (screen ref ↔ API endpoint exists)

| # | Screen API Ref | Files Using It |
|---|---|---|
| 1 | `ABTestService/EvaluateTest` | 1 screen(s) |
| 2 | `ABTestService/GetMetrics` | 1 screen(s) |
| 3 | `AIPreferenceService/Get` | 1 screen(s) |
| 4 | `AIPreferenceService/ResetDefaults` | 1 screen(s) |
| 5 | `AIService/AddSFX` | 1 screen(s) |
| 6 | `AIService/AnalyzeClips` | 1 screen(s) |
| 7 | `AIService/AnalyzeScenes` | 1 screen(s) |
| 8 | `AIService/AnalyzeStyle` | 1 screen(s) |
| 9 | `AIService/AnalyzeTranscript` | 1 screen(s) |
| 10 | `AIService/AnalyzeVideo` | 1 screen(s) |
| 11 | `AIService/BatchSuggestReplies` | 1 screen(s) |
| 12 | `AIService/BeatSync` | 1 screen(s) |
| 13 | `AIService/ExtractKeyPoints` | 1 screen(s) |
| 14 | `AIService/GenerateCharacterPreview` | 1 screen(s) |
| 15 | `AIService/GenerateLiveCueCards` | 1 screen(s) |
| 16 | `AIService/GenerateLiveInsights` | 1 screen(s) |
| 17 | `AIService/GenerateMusic` | 3 screen(s) |
| 18 | `AIService/GenerateScript` | 1 screen(s) |
| 19 | `AIService/GenerateThumbnails` | 1 screen(s) |
| 20 | `AIService/GenerateVariants` | 1 screen(s) |
| 21 | `AIService/GenerateVoice` | 1 screen(s) |
| 22 | `AIService/GetPricingIntelligence` | 1 screen(s) |
| 23 | `AIService/GetProviderStatus` | 1 screen(s) |
| 24 | `AIService/Rephrase` | 1 screen(s) |
| 25 | `AIService/ScanBankStatement` | 1 screen(s) |
| 26 | `AIService/ScanReceipt` | 1 screen(s) |
| 27 | `AIService/ScrapeURL` | 1 screen(s) |
| 28 | `AIService/SpeechToSong` | 1 screen(s) |
| 29 | `AIService/SuggestDerivatives` | 1 screen(s) |
| 30 | `AIService/SuggestRates` | 1 screen(s) |
| 31 | `AIService/SuggestReply` | 1 screen(s) |
| 32 | `AIService/Transcribe` | 1 screen(s) |
| 33 | `AIService/TranslateScript` | 1 screen(s) |
| 34 | `APIKeyService/Create` | 1 screen(s) |
| 35 | `APIKeyService/GetUsage` | 1 screen(s) |
| 36 | `APIKeyService/GetUsageStats` | 1 screen(s) |
| 37 | `APIKeyService/List` | 1 screen(s) |
| 38 | `APIKeyService/Revoke` | 1 screen(s) |
| 39 | `APIKeyService/Rotate` | 1 screen(s) |
| 40 | `APIKeyService/UpdateScopes` | 1 screen(s) |
| 41 | `AccountService/GetStatus` | 2 screen(s) |
| 42 | `ActivityService/List` | 1 screen(s) |
| 43 | `AdminAIService/EstimateCost` | 1 screen(s) |
| 44 | `AdminAIService/GetConfig` | 1 screen(s) |
| 45 | `AdminAIService/GetPromptHistory` | 1 screen(s) |
| 46 | `AdminAIService/GetPrompts` | 1 screen(s) |
| 47 | `AdminAIService/GetRateLimits` | 1 screen(s) |
| 48 | `AdminAIService/ListABTests` | 1 screen(s) |
| 49 | `AdminAIService/ListModels` | 1 screen(s) |
| 50 | `AdminAIService/ResetPrompts` | 1 screen(s) |
| 51 | `AdminAIService/StopABTest` | 1 screen(s) |
| 52 | `AdminAIService/UpdateConfig` | 1 screen(s) |
| 53 | `AdminAIService/UpdateRateLimits` | 1 screen(s) |
| 54 | `AdminAbuseService/ActionReport` | 1 screen(s) |
| 55 | `AdminAbuseService/BanUser` | 1 screen(s) |
| 56 | `AdminAbuseService/BulkAction` | 1 screen(s) |
| 57 | `AdminAbuseService/Dismiss` | 1 screen(s) |
| 58 | `AdminAbuseService/Escalate` | 1 screen(s) |
| 59 | `AdminAbuseService/GetEvidence` | 1 screen(s) |
| 60 | `AdminAbuseService/GetFullReport` | 1 screen(s) |
| 61 | `AdminAbuseService/GetSLACompliance` | 1 screen(s) |
| 62 | `AdminAbuseService/GetStats` | 1 screen(s) |
| 63 | `AdminAbuseService/GetUserHistory` | 1 screen(s) |
| 64 | `AdminAbuseService/ListReports` | 1 screen(s) |
| 65 | `AdminAbuseService/RemoveContent` | 1 screen(s) |
| 66 | `AdminAbuseService/SuspendUser` | 1 screen(s) |
| 67 | `AdminAbuseService/WarnUser` | 1 screen(s) |
| 68 | `AdminAlertService/Dismiss` | 1 screen(s) |
| 69 | `AdminAlertService/GetActive` | 1 screen(s) |
| 70 | `AdminAnalyticsService/Export` | 1 screen(s) |
| 71 | `AdminAnalyticsService/GetBusinessMetrics` | 1 screen(s) |
| 72 | `AdminAnalyticsService/GetCohortRetention` | 1 screen(s) |
| 73 | `AdminAnalyticsService/GetComparison` | 1 screen(s) |
| 74 | `AdminAnalyticsService/GetConversionFunnel` | 1 screen(s) |
| 75 | `AdminAnalyticsService/GetInsights` | 1 screen(s) |
| 76 | `AdminAnalyticsService/GetMRRTrend` | 1 screen(s) |
| 77 | `AdminBroadcastService/Cancel` | 1 screen(s) |
| 78 | `AdminBroadcastService/EstimateReach` | 1 screen(s) |
| 79 | `AdminBroadcastService/ListHistory` | 1 screen(s) |
| 80 | `AdminBroadcastService/ListScheduled` | 1 screen(s) |
| 81 | `AdminBroadcastService/PreviewEmail` | 1 screen(s) |
| 82 | `AdminBroadcastService/Schedule` | 1 screen(s) |
| 83 | `AdminBroadcastService/Send` | 1 screen(s) |
| 84 | `AdminBroadcastService/SendNow` | 1 screen(s) |
| 85 | `AdminBroadcastService/SendTest` | 1 screen(s) |
| 86 | `AdminCommerceService/AddNote` | 1 screen(s) |
| 87 | `AdminCommerceService/EscalateDispute` | 1 screen(s) |
| 88 | `AdminCommerceService/ResolveDispute` | 1 screen(s) |
| 89 | `AdminComplianceService/ApproveDeletion` | 1 screen(s) |
| 90 | `AdminComplianceService/CreateBreach` | 1 screen(s) |
| 91 | `AdminComplianceService/ExportDPA` | 1 screen(s) |
| 92 | `AdminComplianceService/GenerateExport` | 1 screen(s) |
| 93 | `AdminComplianceService/GetBreaches` | 1 screen(s) |
| 94 | `AdminComplianceService/GetDPALog` | 1 screen(s) |
| 95 | `AdminComplianceService/GetRequest` | 1 screen(s) |
| 96 | `AdminComplianceService/GetStats` | 1 screen(s) |
| 97 | `AdminComplianceService/GetUserConsents` | 1 screen(s) |
| 98 | `AdminComplianceService/ListRequests` | 1 screen(s) |
| 99 | `AdminComplianceService/RejectRequest` | 1 screen(s) |
| 100 | `AdminConfigService/GetAIRates` | 1 screen(s) |
| 101 | `AdminConfigService/GetChangeHistory` | 1 screen(s) |
| 102 | `AdminConfigService/GetMaintenance` | 1 screen(s) |
| 103 | `AdminConfigService/GetPricing` | 1 screen(s) |
| 104 | `AdminConfigService/GetRateLimits` | 1 screen(s) |
| 105 | `AdminConfigService/UpdateCreditRate` | 1 screen(s) |
| 106 | `AdminConfigService/UpdateEmailTemplate` | 1 screen(s) |
| 107 | `AdminConfigService/UpdateRateLimit` | 1 screen(s) |
| 108 | `AdminConfigService/UpdateTier` | 1 screen(s) |
| 109 | `AdminCreditService/BulkGrant` | 1 screen(s) |
| 110 | `AdminCreditService/Export` | 1 screen(s) |
| 111 | `AdminCreditService/GetConsumptionTrend` | 1 screen(s) |
| 112 | `AdminCreditService/GetPlanAllocations` | 1 screen(s) |
| 113 | `AdminCreditService/GetPoolStatus` | 1 screen(s) |
| 114 | `AdminCreditService/Grant` | 1 screen(s) |
| 115 | `AdminCreditService/ListTransactions` | 1 screen(s) |
| 116 | `AdminCreditService/Revoke` | 1 screen(s) |
| 117 | `AdminCreditService/UpdateAllocations` | 1 screen(s) |
| 118 | `AdminEmailService/Send` | 1 screen(s) |
| 119 | `AdminFeeService/CreateRule` | 1 screen(s) |
| 120 | `AdminFeeService/DeactivateRule` | 1 screen(s) |
| 121 | `AdminFeeService/DeleteRule` | 1 screen(s) |
| 122 | `AdminFeeService/GetHistory` | 1 screen(s) |
| 123 | `AdminFeeService/GetRevenueStats` | 1 screen(s) |
| 124 | `AdminFeeService/ListRules` | 1 screen(s) |
| 125 | `AdminFeeService/SimulateImpact` | 1 screen(s) |
| 126 | `AdminFeeService/UpdateRule` | 1 screen(s) |
| 127 | `AdminFraudService/BulkAction` | 1 screen(s) |
| 128 | `AdminFraudService/CreateCase` | 1 screen(s) |
| 129 | `AdminFraudService/ExportReport` | 1 screen(s) |
| 130 | `AdminFraudService/GetDeviceIntel` | 1 screen(s) |
| 131 | `AdminFraudService/GetImpact` | 1 screen(s) |
| 132 | `AdminFraudService/GetMetrics` | 1 screen(s) |
| 133 | `AdminFraudService/GetSignals` | 1 screen(s) |
| 134 | `AdminFraudService/ListCases` | 1 screen(s) |
| 135 | `AdminFraudService/SearchCases` | 1 screen(s) |
| 136 | `AdminIncidentService/Create` | 1 screen(s) |
| 137 | `AdminIncidentService/CreatePostMortem` | 1 screen(s) |
| 138 | `AdminIncidentService/Escalate` | 1 screen(s) |
| 139 | `AdminIncidentService/GetActive` | 1 screen(s) |
| 140 | `AdminIncidentService/GetMetrics` | 1 screen(s) |
| 141 | `AdminIncidentService/List` | 1 screen(s) |
| 142 | `AdminIncidentService/Resolve` | 1 screen(s) |
| 143 | `AdminIncidentService/Update` | 1 screen(s) |
| 144 | `AdminJobService/ClearCompleted` | 1 screen(s) |
| 145 | `AdminJobService/GetJob` | 1 screen(s) |
| 146 | `AdminJobService/GetQueueHistory` | 1 screen(s) |
| 147 | `AdminJobService/GetQueueStats` | 1 screen(s) |
| 148 | `AdminJobService/KillJob` | 1 screen(s) |
| 149 | `AdminJobService/ListJobs` | 1 screen(s) |
| 150 | `AdminJobService/PauseJob` | 1 screen(s) |
| 151 | `AdminJobService/RetryAllFailed` | 1 screen(s) |
| 152 | `AdminJobService/RetryJob` | 1 screen(s) |
| 153 | `AdminJobService/StreamLogs` | 1 screen(s) |
| 154 | `AdminManagementService/CreateAdmin` | 1 screen(s) |
| 155 | `AdminManagementService/Deactivate` | 1 screen(s) |
| 156 | `AdminManagementService/GetAdminActivity` | 1 screen(s) |
| 157 | `AdminManagementService/GetSecurityOverview` | 1 screen(s) |
| 158 | `AdminManagementService/KillSessions` | 1 screen(s) |
| 159 | `AdminManagementService/ListAdmins` | 1 screen(s) |
| 160 | `AdminManagementService/Reactivate` | 1 screen(s) |
| 161 | `AdminManagementService/ResetMFA` | 1 screen(s) |
| 162 | `AdminManagementService/UpdateRole` | 1 screen(s) |
| 163 | `AdminRevenueService/Export` | 1 screen(s) |
| 164 | `AdminRevenueService/GetComparison` | 1 screen(s) |
| 165 | `AdminRevenueService/GetPaymentHealth` | 1 screen(s) |
| 166 | `AdminRevenueService/GetSummary` | 1 screen(s) |
| 167 | `AdminRevenueService/GetTrend` | 1 screen(s) |
| 168 | `AdminRevenueService/ListTransactions` | 1 screen(s) |
| 169 | `AdminRevenueService/RetryPayment` | 1 screen(s) |
| 170 | `AdminService/AdjustCredits` | 1 screen(s) |
| 171 | `AdminService/BulkSuspend` | 1 screen(s) |
| 172 | `AdminService/DeleteUser` | 1 screen(s) |
| 173 | `AdminService/DeleteWorkspace` | 1 screen(s) |
| 174 | `AdminService/ExportWorkspaces` | 1 screen(s) |
| 175 | `AdminService/ForceLogout` | 1 screen(s) |
| 176 | `AdminService/GetAIOps` | 1 screen(s) |
| 177 | `AdminService/GetDashboard` | 1 screen(s) |
| 178 | `AdminService/GetRecentActivity` | 1 screen(s) |
| 179 | `AdminService/GetRelatedTickets` | 1 screen(s) |
| 180 | `AdminService/GetRevenueSummary` | 1 screen(s) |
| 181 | `AdminService/GetSupportSummary` | 1 screen(s) |
| 182 | `AdminService/GetSystemHealth` | 1 screen(s) |
| 183 | `AdminService/GetUser` | 1 screen(s) |
| 184 | `AdminService/GetUserActivity` | 1 screen(s) |
| 185 | `AdminService/GetUserContentStats` | 1 screen(s) |
| 186 | `AdminService/GetUserCredits` | 1 screen(s) |
| 187 | `AdminService/GetUserSecurity` | 1 screen(s) |
| 188 | `AdminService/GetUserWorkspaces` | 1 screen(s) |
| 189 | `AdminService/GetWorkspaceStats` | 1 screen(s) |
| 190 | `AdminService/GrantCredits` | 1 screen(s) |
| 191 | `AdminService/Impersonate` | 1 screen(s) |
| 192 | `AdminService/ListWorkspaces` | 1 screen(s) |
| 193 | `AdminService/OverridePlan` | 2 screen(s) |
| 194 | `AdminService/ResetPassword` | 1 screen(s) |
| 195 | `AdminService/SuspendUser` | 1 screen(s) |
| 196 | `AdminService/SuspendWorkspace` | 1 screen(s) |
| 197 | `AdminService/UnsuspendUser` | 1 screen(s) |
| 198 | `AdminService/UnsuspendWorkspace` | 1 screen(s) |
| 199 | `AdminUserService/Invite` | 1 screen(s) |
| 200 | `AdminUserService/Reactivate` | 1 screen(s) |
| 201 | `AdminUserService/ResetPassword` | 1 screen(s) |
| 202 | `AdminUserService/Suspend` | 1 screen(s) |
| 203 | `AffiliateService/Create` | 1 screen(s) |
| 204 | `AffiliateService/CreateLink` | 1 screen(s) |
| 205 | `AffiliateService/Delete` | 1 screen(s) |
| 206 | `AffiliateService/DeleteLink` | 1 screen(s) |
| 207 | `AffiliateService/ExportReport` | 1 screen(s) |
| 208 | `AffiliateService/GetKPIs` | 1 screen(s) |
| 209 | `AffiliateService/GetSourceContent` | 1 screen(s) |
| 210 | `AffiliateService/List` | 2 screen(s) |
| 211 | `AffiliateService/ListLinks` | 1 screen(s) |
| 212 | `AffiliateService/Pause` | 1 screen(s) |
| 213 | `AffiliateService/RenewLink` | 1 screen(s) |
| 214 | `AffiliateService/Resume` | 1 screen(s) |
| 215 | `AffiliateService/RunHealthCheck` | 1 screen(s) |
| 216 | `AgentService/CancelRun` | 1 screen(s) |
| 217 | `AgentService/LaunchAgent` | 1 screen(s) |
| 218 | `AgentService/ListRuns` | 1 screen(s) |
| 219 | `AgentService/ProvideInput` | 1 screen(s) |
| 220 | `AgentService/StreamRun` | 1 screen(s) |
| 221 | `AlertService/Dismiss` | 2 screen(s) |
| 222 | `AlertService/GetActive` | 1 screen(s) |
| 223 | `AnalyticsService/BatchGetPostMetrics` | 2 screen(s) |
| 224 | `AnalyticsService/ExportCSV` | 1 screen(s) |
| 225 | `AnalyticsService/ExportPDF` | 1 screen(s) |
| 226 | `AnalyticsService/GetAggregateMetrics` | 1 screen(s) |
| 227 | `AnalyticsService/GetBenchmarkData` | 1 screen(s) |
| 228 | `AnalyticsService/GetBestPostingTime` | 1 screen(s) |
| 229 | `AnalyticsService/GetBestPostingTimes` | 3 screen(s) |
| 230 | `AnalyticsService/GetChannelsSummary` | 1 screen(s) |
| 231 | `AnalyticsService/GetContentTypeBreakdown` | 1 screen(s) |
| 232 | `AnalyticsService/GetDashboard` | 1 screen(s) |
| 233 | `AnalyticsService/GetDemographics` | 1 screen(s) |
| 234 | `AnalyticsService/GetGrowthSeries` | 1 screen(s) |
| 235 | `AnalyticsService/GetIdeaOutcome` | 1 screen(s) |
| 236 | `AnalyticsService/GetOverview` | 2 screen(s) |
| 237 | `AnalyticsService/GetPlatformBreakdown` | 1 screen(s) |
| 238 | `AnalyticsService/GetPlatformKPIs` | 1 screen(s) |
| 239 | `AnalyticsService/GetPlatformReliability` | 1 screen(s) |
| 240 | `AnalyticsService/GetPostDetail` | 1 screen(s) |
| 241 | `AnalyticsService/GetPostMetrics` | 1 screen(s) |
| 242 | `AnalyticsService/GetTimeSeries` | 1 screen(s) |
| 243 | `AnalyticsService/GetTopContent` | 3 screen(s) |
| 244 | `AnalyticsService/GetTopPerformer` | 1 screen(s) |
| 245 | `AnalyticsService/GetWeeklySummary` | 1 screen(s) |
| 246 | `ApprovalService/Approve` | 1 screen(s) |
| 247 | `ApprovalService/BatchApprove` | 2 screen(s) |
| 248 | `ApprovalService/GetQueueStats` | 1 screen(s) |
| 249 | `ApprovalService/ListPending` | 2 screen(s) |
| 250 | `ApprovalService/Reject` | 1 screen(s) |
| 251 | `ApprovalService/UndoApprove` | 1 screen(s) |
| 252 | `ApprovalService/UndoReject` | 1 screen(s) |
| 253 | `AssetService/AnalyzeCreativeDNA` | 1 screen(s) |
| 254 | `AssetService/AutoCrop` | 1 screen(s) |
| 255 | `AssetService/BatchExport` | 1 screen(s) |
| 256 | `AssetService/Export` | 1 screen(s) |
| 257 | `AssetService/ExtractFrames` | 1 screen(s) |
| 258 | `AssetService/FetchReference` | 1 screen(s) |
| 259 | `AssetService/Generate` | 9 screen(s) |
| 260 | `AssetService/Get` | 3 screen(s) |
| 261 | `AssetService/GetDownloadURL` | 1 screen(s) |
| 262 | `AssetService/GetPreview` | 1 screen(s) |
| 263 | `AssetService/List` | 2 screen(s) |
| 264 | `AssetService/ListMusicGenres` | 1 screen(s) |
| 265 | `AssetService/ListRecent` | 1 screen(s) |
| 266 | `AssetService/Upload` | 3 screen(s) |
| 267 | `AttributionService/GetByContent` | 1 screen(s) |
| 268 | `AuthService/Register` | 1 screen(s) |
| 269 | `AuthService/RequestPasswordReset` | 1 screen(s) |
| 270 | `BenchmarkService/Compare` | 1 screen(s) |
| 271 | `BenchmarkService/GetTimeSeries` | 1 screen(s) |
| 272 | `BillingService/ApplyRetentionDiscount` | 1 screen(s) |
| 273 | `BillingService/Cancel` | 1 screen(s) |
| 274 | `BillingService/CancelPlan` | 1 screen(s) |
| 275 | `BillingService/ChangePlan` | 2 screen(s) |
| 276 | `BillingService/GetCheckoutStatus` | 1 screen(s) |
| 277 | `BillingService/GetCurrentPlan` | 1 screen(s) |
| 278 | `BillingService/GetInvoiceUrl` | 1 screen(s) |
| 279 | `BillingService/GetPaymentMethods` | 2 screen(s) |
| 280 | `BillingService/GetSubscription` | 1 screen(s) |
| 281 | `BillingService/ListCreditPackages` | 1 screen(s) |
| 282 | `BillingService/ListCreditPurchases` | 1 screen(s) |
| 283 | `BillingService/ListInvoices` | 2 screen(s) |
| 284 | `BillingService/ListPlans` | 1 screen(s) |
| 285 | `BrandDealService/GetPipelineStats` | 1 screen(s) |
| 286 | `BrandDealService/GetSummary` | 1 screen(s) |
| 287 | `BrandDealService/ListDeals` | 1 screen(s) |
| 288 | `BrandDealService/ListPartnerships` | 1 screen(s) |
| 289 | `BrandDealService/UpdateDeliverable` | 1 screen(s) |
| 290 | `BrandDealService/UpdatePayment` | 1 screen(s) |
| 291 | `BrandDealService/UpdateStatus` | 1 screen(s) |
| 292 | `BrandPackService/Create` | 1 screen(s) |
| 293 | `BrandPackService/Get` | 1 screen(s) |
| 294 | `BrandPackService/GetActive` | 1 screen(s) |
| 295 | `BrandPackService/List` | 1 screen(s) |
| 296 | `BrandPackService/Update` | 1 screen(s) |
| 297 | `BrandPackService/UploadLogo` | 1 screen(s) |
| 298 | `BriefService/AddShot` | 1 screen(s) |
| 299 | `BriefService/DeleteShot` | 1 screen(s) |
| 300 | `BriefService/EmailBrief` | 1 screen(s) |
| 301 | `BriefService/Get` | 1 screen(s) |
| 302 | `BriefService/GetBrief` | 1 screen(s) |
| 303 | `BriefService/GetMorningBrief` | 1 screen(s) |
| 304 | `BriefService/GetSuggestedActions` | 1 screen(s) |
| 305 | `BriefService/GetWarnings` | 1 screen(s) |
| 306 | `BriefService/RegenerateBrief` | 1 screen(s) |
| 307 | `BriefService/ReorderShots` | 1 screen(s) |
| 308 | `BriefService/Update` | 1 screen(s) |
| 309 | `BriefService/UpdateShot` | 1 screen(s) |
| 310 | `CampaignService/AddCost` | 1 screen(s) |
| 311 | `CampaignService/Create` | 1 screen(s) |
| 312 | `CampaignService/Delete` | 1 screen(s) |
| 313 | `CampaignService/Duplicate` | 3 screen(s) |
| 314 | `CampaignService/End` | 1 screen(s) |
| 315 | `CampaignService/ExportReport` | 1 screen(s) |
| 316 | `CampaignService/Get` | 1 screen(s) |
| 317 | `CampaignService/GetCosts` | 1 screen(s) |
| 318 | `CampaignService/GetFunnel` | 1 screen(s) |
| 319 | `CampaignService/GetLinkedContent` | 1 screen(s) |
| 320 | `CampaignService/GetLinkedOffers` | 1 screen(s) |
| 321 | `CampaignService/GetMetrics` | 1 screen(s) |
| 322 | `CampaignService/GetPlatformBreakdown` | 1 screen(s) |
| 323 | `CampaignService/GetRevenueTimeline` | 1 screen(s) |
| 324 | `CampaignService/GetTopProducts` | 1 screen(s) |
| 325 | `CampaignService/LinkContent` | 1 screen(s) |
| 326 | `CampaignService/LinkOffer` | 1 screen(s) |
| 327 | `CampaignService/List` | 2 screen(s) |
| 328 | `CampaignService/Pause` | 2 screen(s) |
| 329 | `CampaignService/Resume` | 2 screen(s) |
| 330 | `CampaignService/UnlinkContent` | 1 screen(s) |
| 331 | `CampaignService/Update` | 1 screen(s) |
| 332 | `CapabilityService/GetMatrix` | 1 screen(s) |
| 333 | `CapabilityService/GetRecentIssues` | 1 screen(s) |
| 334 | `CapabilityService/GetSnapshots` | 1 screen(s) |
| 335 | `CapabilityService/GetSystemStatus` | 1 screen(s) |
| 336 | `CharacterService/Create` | 1 screen(s) |
| 337 | `CharacterService/Delete` | 1 screen(s) |
| 338 | `CharacterService/Get` | 1 screen(s) |
| 339 | `CharacterService/Update` | 1 screen(s) |
| 340 | `CommerceService/GetDashboard` | 1 screen(s) |
| 341 | `CommerceService/GetTopProducts` | 1 screen(s) |
| 342 | `CompetitorService/Add` | 1 screen(s) |
| 343 | `CompetitorService/DismissSuggestion` | 1 screen(s) |
| 344 | `CompetitorService/GetSuggestions` | 1 screen(s) |
| 345 | `CompetitorService/List` | 1 screen(s) |
| 346 | `CompetitorService/Remove` | 1 screen(s) |
| 347 | `CompetitorService/SetAlerts` | 1 screen(s) |
| 348 | `CompetitorService/ValidateHandle` | 1 screen(s) |
| 349 | `ConnectorService/Check` | 1 screen(s) |
| 350 | `ConnectorService/CheckRequirements` | 1 screen(s) |
| 351 | `ConnectorService/CountActive` | 2 screen(s) |
| 352 | `ConnectorService/Disconnect` | 2 screen(s) |
| 353 | `ConnectorService/ForceSync` | 1 screen(s) |
| 354 | `ConnectorService/Get` | 1 screen(s) |
| 355 | `ConnectorService/GetAllStatus` | 2 screen(s) |
| 356 | `ConnectorService/GetSyncStatus` | 3 screen(s) |
| 357 | `ConnectorService/GetTokenStatus` | 1 screen(s) |
| 358 | `ConnectorService/List` | 1 screen(s) |
| 359 | `ConnectorService/ListActive` | 2 screen(s) |
| 360 | `ConnectorService/ListConnected` | 1 screen(s) |
| 361 | `ConnectorService/RefreshToken` | 3 screen(s) |
| 362 | `ConnectorService/Reply` | 3 screen(s) |
| 363 | `ConnectorService/ReplyComment` | 1 screen(s) |
| 364 | `ConnectorService/SyncOrder` | 1 screen(s) |
| 365 | `ConnectorService/SyncOrders` | 1 screen(s) |
| 366 | `ConnectorService/SyncProduct` | 1 screen(s) |
| 367 | `ConnectorService/SyncProducts` | 1 screen(s) |
| 368 | `ConnectorService/TriggerSync` | 1 screen(s) |
| 369 | `ConnectorService/UpdateRetentionPolicy` | 1 screen(s) |
| 370 | `ConnectorService/UpdateSyncConfig` | 1 screen(s) |
| 371 | `ConsentService/Grant` | 1 screen(s) |
| 372 | `ConsentService/Revoke` | 1 screen(s) |
| 373 | `ContactService/Export` | 1 screen(s) |
| 374 | `ContactService/GetSummary` | 1 screen(s) |
| 375 | `ContactService/List` | 1 screen(s) |
| 376 | `ContactService/Search` | 1 screen(s) |
| 377 | `ContactService/UpdateVIP` | 1 screen(s) |
| 378 | `ContentPerformanceService/GetStats` | 1 screen(s) |
| 379 | `ContentRevenueService/GetAttribution` | 1 screen(s) |
| 380 | `ContentService/AttachMedia` | 1 screen(s) |
| 381 | `ContentService/FindMentions` | 1 screen(s) |
| 382 | `ContentService/GetCaptionStyles` | 1 screen(s) |
| 383 | `ContentService/GetHookTemplates` | 1 screen(s) |
| 384 | `ContinuityService/Clone` | 1 screen(s) |
| 385 | `ContinuityService/Create` | 1 screen(s) |
| 386 | `ContinuityService/Delete` | 1 screen(s) |
| 387 | `ContinuityService/Get` | 1 screen(s) |
| 388 | `ContinuityService/GetUsageStats` | 1 screen(s) |
| 389 | `ContinuityService/ListBrandPacks` | 1 screen(s) |
| 390 | `ContinuityService/ListCharacters` | 1 screen(s) |
| 391 | `ContinuityService/ListVoices` | 1 screen(s) |
| 392 | `CopilotService/AnalyticsInsights` | 1 screen(s) |
| 393 | `CopilotService/AnalyzeAnalytics` | 1 screen(s) |
| 394 | `CopilotService/AnalyzePipeline` | 1 screen(s) |
| 395 | `CopilotService/Chat` | 2 screen(s) |
| 396 | `CopilotService/CheckBrandVoice` | 2 screen(s) |
| 397 | `CopilotService/ClearSession` | 1 screen(s) |
| 398 | `CopilotService/DismissReply` | 1 screen(s) |
| 399 | `CopilotService/Feedback` | 2 screen(s) |
| 400 | `CopilotService/FinanceInsight` | 1 screen(s) |
| 401 | `CopilotService/GenerateAvatar` | 1 screen(s) |
| 402 | `CopilotService/GenerateCaption` | 1 screen(s) |
| 403 | `CopilotService/GenerateIdeas` | 1 screen(s) |
| 404 | `CopilotService/GenerateReply` | 1 screen(s) |
| 405 | `CopilotService/GetContentOptimization` | 1 screen(s) |
| 406 | `CopilotService/GetCostOptimization` | 1 screen(s) |
| 407 | `CopilotService/GetOptimalTimes` | 1 screen(s) |
| 408 | `CopilotService/GetSession` | 1 screen(s) |
| 409 | `CopilotService/GetSuggestions` | 1 screen(s) |
| 410 | `CopilotService/Query` | 9 screen(s) |
| 411 | `CopilotService/RegenerateSection` | 1 screen(s) |
| 412 | `CopilotService/ScoreIdea` | 2 screen(s) |
| 413 | `CopilotService/SendMessage` | 1 screen(s) |
| 414 | `CopilotService/ShortenCaption` | 1 screen(s) |
| 415 | `CopilotService/SuggestHashtags` | 1 screen(s) |
| 416 | `CopilotService/TrendInsight` | 1 screen(s) |
| 417 | `CostService/CreateCostItem` | 1 screen(s) |
| 418 | `CostService/CreateEntry` | 1 screen(s) |
| 419 | `CostService/DeleteEntry` | 1 screen(s) |
| 420 | `CostService/GetBreakdown` | 1 screen(s) |
| 421 | `CostService/UpdateEntry` | 1 screen(s) |
| 422 | `CouponService/CheckAvailability` | 1 screen(s) |
| 423 | `CouponService/Create` | 2 screen(s) |
| 424 | `CouponService/Deactivate` | 1 screen(s) |
| 425 | `CouponService/Delete` | 1 screen(s) |
| 426 | `CouponService/List` | 1 screen(s) |
| 427 | `CouponService/Pause` | 1 screen(s) |
| 428 | `CouponService/Resume` | 1 screen(s) |
| 429 | `CouponService/Update` | 1 screen(s) |
| 430 | `CreatorProService/GetDashboard` | 1 screen(s) |
| 431 | `CreatorProfileService/GetStats` | 1 screen(s) |
| 432 | `CreditService/GetAutoRefillConfig` | 2 screen(s) |
| 433 | `CreditService/GetBalance` | 14 screen(s) |
| 434 | `CreditService/GetCheckoutStatus` | 1 screen(s) |
| 435 | `CreditService/GetMonthlyUsage` | 1 screen(s) |
| 436 | `CreditService/GetUsageStats` | 1 screen(s) |
| 437 | `CreditService/ListPackages` | 2 screen(s) |
| 438 | `CreditService/ListRecentUsage` | 1 screen(s) |
| 439 | `CreditService/ListTransactions` | 1 screen(s) |
| 440 | `CreditService/Purchase` | 1 screen(s) |
| 441 | `CreditService/UpdateAutoRefill` | 2 screen(s) |
| 442 | `DashboardService/GetMobileHome` | 1 screen(s) |
| 443 | `DashboardService/GetPipeline` | 1 screen(s) |
| 444 | `DataService/GetExportUrl` | 1 screen(s) |
| 445 | `DataService/RequestExport` | 1 screen(s) |
| 446 | `DerivativeService/Create` | 1 screen(s) |
| 447 | `DerivativeService/Delete` | 1 screen(s) |
| 448 | `DiagnosticsService/ExecuteRepairStep` | 1 screen(s) |
| 449 | `DiagnosticsService/GetHealthGrid` | 1 screen(s) |
| 450 | `DiagnosticsService/GetOverview` | 1 screen(s) |
| 451 | `DiagnosticsService/ListIssues` | 1 screen(s) |
| 452 | `DiagnosticsService/RunFullCheck` | 1 screen(s) |
| 453 | `EntityService/AddNote` | 1 screen(s) |
| 454 | `EntityService/AddTag` | 2 screen(s) |
| 455 | `EntityService/List` | 1 screen(s) |
| 456 | `ErrorLogService/GetRecent` | 1 screen(s) |
| 457 | `EventService/create` | 1 screen(s) |
| 458 | `ExchangeRateService/GetRates` | 1 screen(s) |
| 459 | `FeatureFlagService/Archive` | 1 screen(s) |
| 460 | `FeatureFlagService/Create` | 1 screen(s) |
| 461 | `FeatureFlagService/Update` | 1 screen(s) |
| 462 | `FileService/GetMetadata` | 1 screen(s) |
| 463 | `FileService/Upload` | 2 screen(s) |
| 464 | `FollowUpTaskService/Complete` | 1 screen(s) |
| 465 | `FollowUpTaskService/Create` | 5 screen(s) |
| 466 | `FollowUpTaskService/Reschedule` | 1 screen(s) |
| 467 | `GamificationService/GetAchievements` | 1 screen(s) |
| 468 | `GamificationService/GetActiveQuests` | 1 screen(s) |
| 469 | `GamificationService/GetDashboard` | 1 screen(s) |
| 470 | `GamificationService/GetLeaderboard` | 1 screen(s) |
| 471 | `GamificationService/GetStreak` | 1 screen(s) |
| 472 | `GenerationService/ListActive` | 1 screen(s) |
| 473 | `GenerationService/StreamActiveJobs` | 1 screen(s) |
| 474 | `GlossaryService/GetTerm` | 1 screen(s) |
| 475 | `GlossaryService/ListTerms` | 1 screen(s) |
| 476 | `IdeaService/AddReference` | 1 screen(s) |
| 477 | `IdeaService/AddTag` | 1 screen(s) |
| 478 | `IdeaService/BulkCreate` | 2 screen(s) |
| 479 | `IdeaService/BulkDelete` | 1 screen(s) |
| 480 | `IdeaService/BulkUpdateStatus` | 1 screen(s) |
| 481 | `IdeaService/Clone` | 1 screen(s) |
| 482 | `IdeaService/Create` | 11 screen(s) |
| 483 | `IdeaService/CreateFromTrend` | 1 screen(s) |
| 484 | `IdeaService/Delete` | 3 screen(s) |
| 485 | `IdeaService/Get` | 1 screen(s) |
| 486 | `IdeaService/GetPipelineCounts` | 1 screen(s) |
| 487 | `IdeaService/GetStatusCounts` | 1 screen(s) |
| 488 | `IdeaService/GetTags` | 1 screen(s) |
| 489 | `IdeaService/List` | 1 screen(s) |
| 490 | `IdeaService/ListMobile` | 1 screen(s) |
| 491 | `IdeaService/RemoveTag` | 1 screen(s) |
| 492 | `IdeaService/Reorder` | 1 screen(s) |
| 493 | `IdeaService/ResScore` | 1 screen(s) |
| 494 | `IdeaService/Rescore` | 1 screen(s) |
| 495 | `IdeaService/Search` | 1 screen(s) |
| 496 | `IdeaService/Update` | 3 screen(s) |
| 497 | `IdeaService/UpdateStatus` | 1 screen(s) |
| 498 | `IdeaService/UpdateTags` | 1 screen(s) |
| 499 | `InventoryService/BulkStockIn` | 1 screen(s) |
| 500 | `InventoryService/CreateStockMovement` | 1 screen(s) |
| 501 | `InventoryService/Export` | 1 screen(s) |
| 502 | `InventoryService/GetAlerts` | 1 screen(s) |
| 503 | `InventoryService/GetSummary` | 1 screen(s) |
| 504 | `InventoryService/ListMovements` | 1 screen(s) |
| 505 | `InventoryService/ListStock` | 1 screen(s) |
| 506 | `InventoryService/UpdateThresholds` | 1 screen(s) |
| 507 | `KBService/GetArticle` | 1 screen(s) |
| 508 | `KBService/GetCategories` | 1 screen(s) |
| 509 | `KBService/GetCategoryCounts` | 1 screen(s) |
| 510 | `KBService/GetPopularArticles` | 1 screen(s) |
| 511 | `KBService/RateArticle` | 1 screen(s) |
| 512 | `LinkInBioService/GetAnalytics` | 1 screen(s) |
| 513 | `LinkInBioService/GetPage` | 1 screen(s) |
| 514 | `LinkInBioService/Reorder` | 1 screen(s) |
| 515 | `LinkInBioService/Save` | 1 screen(s) |
| 516 | `LinkInBioService/UpdateTheme` | 1 screen(s) |
| 517 | `LiveAnalyticsService/GetStatus` | 1 screen(s) |
| 518 | `LiveAnalyticsService/GetSummary` | 1 screen(s) |
| 519 | `LiveService/AddOffer` | 1 screen(s) |
| 520 | `LiveService/AddProduct` | 1 screen(s) |
| 521 | `LiveService/CreateHighlight` | 1 screen(s) |
| 522 | `LiveService/CreateSession` | 1 screen(s) |
| 523 | `LiveService/DeleteSession` | 1 screen(s) |
| 524 | `LiveService/DuplicateSession` | 1 screen(s) |
| 525 | `LiveService/EndSession` | 1 screen(s) |
| 526 | `LiveService/GetLiveStats` | 1 screen(s) |
| 527 | `LiveService/GetSession` | 1 screen(s) |
| 528 | `LiveService/ListSessions` | 1 screen(s) |
| 529 | `LiveService/NextProduct` | 1 screen(s) |
| 530 | `LiveService/ReorderProducts` | 1 screen(s) |
| 531 | `LiveService/Reply` | 1 screen(s) |
| 532 | `LiveService/SaveSetup` | 1 screen(s) |
| 533 | `LiveService/StartSession` | 2 screen(s) |
| 534 | `LiveService/StreamStats` | 1 screen(s) |
| 535 | `LiveService/TriggerFlashSale` | 1 screen(s) |
| 536 | `MediaKitService/GetKit` | 1 screen(s) |
| 537 | `MembershipService/Archive` | 1 screen(s) |
| 538 | `MembershipService/CreatePlan` | 1 screen(s) |
| 539 | `MembershipService/Delete` | 1 screen(s) |
| 540 | `MembershipService/DuplicatePlan` | 1 screen(s) |
| 541 | `MembershipService/GetMRRSummary` | 1 screen(s) |
| 542 | `MembershipService/GetMRRTrend` | 1 screen(s) |
| 543 | `MembershipService/ListPlans` | 1 screen(s) |
| 544 | `MembershipService/Pause` | 1 screen(s) |
| 545 | `MembershipService/Publish` | 1 screen(s) |
| 546 | `MembershipService/Resume` | 1 screen(s) |
| 547 | `MembershipService/UpdatePlan` | 1 screen(s) |
| 548 | `ModelService/ListAvailable` | 1 screen(s) |
| 549 | `NavigationService/pushThread` | 1 screen(s) |
| 550 | `NotificationService/Delete` | 1 screen(s) |
| 551 | `NotificationService/GetPreferences` | 1 screen(s) |
| 552 | `NotificationService/GetQuietHours` | 1 screen(s) |
| 553 | `NotificationService/GetUnreadCount` | 1 screen(s) |
| 554 | `NotificationService/List` | 1 screen(s) |
| 555 | `NotificationService/MarkAllRead` | 2 screen(s) |
| 556 | `NotificationService/MarkRead` | 2 screen(s) |
| 557 | `NotificationService/ResetPreferences` | 1 screen(s) |
| 558 | `NotificationService/SavePreferences` | 1 screen(s) |
| 559 | `NotificationService/Send` | 2 screen(s) |
| 560 | `NotificationService/SendAlert` | 1 screen(s) |
| 561 | `NotificationService/SendBriefEmail` | 1 screen(s) |
| 562 | `NotificationService/SendReminder` | 1 screen(s) |
| 563 | `NotificationService/ShareBrief` | 1 screen(s) |
| 564 | `NotificationService/UpdateDigestFrequency` | 1 screen(s) |
| 565 | `NotificationService/UpdateQuietHours` | 1 screen(s) |
| 566 | `OfferService/Activate` | 1 screen(s) |
| 567 | `OfferService/BulkPause` | 1 screen(s) |
| 568 | `OfferService/Create` | 1 screen(s) |
| 569 | `OfferService/Delete` | 2 screen(s) |
| 570 | `OfferService/Duplicate` | 2 screen(s) |
| 571 | `OfferService/Get` | 1 screen(s) |
| 572 | `OfferService/GetPerformance` | 1 screen(s) |
| 573 | `OfferService/GetRedemptionStats` | 1 screen(s) |
| 574 | `OfferService/GetStatusCounts` | 1 screen(s) |
| 575 | `OfferService/GetTabSummary` | 1 screen(s) |
| 576 | `OfferService/List` | 2 screen(s) |
| 577 | `OfferService/Pause` | 3 screen(s) |
| 578 | `OfferService/Resume` | 3 screen(s) |
| 579 | `OfferService/Update` | 1 screen(s) |
| 580 | `OpportunityService/Dismiss` | 2 screen(s) |
| 581 | `OpportunityService/Get` | 2 screen(s) |
| 582 | `OpportunityService/List` | 1 screen(s) |
| 583 | `OpportunityService/ListRelated` | 1 screen(s) |
| 584 | `OpportunityService/Save` | 2 screen(s) |
| 585 | `OrderService/BulkCancel` | 1 screen(s) |
| 586 | `OrderService/BulkUpdateStatus` | 1 screen(s) |
| 587 | `OrderService/Confirm` | 1 screen(s) |
| 588 | `OrderService/GetDailyStats` | 1 screen(s) |
| 589 | `OrderService/GetLabel` | 1 screen(s) |
| 590 | `OrderService/GetTodayStats` | 2 screen(s) |
| 591 | `OrderService/List` | 2 screen(s) |
| 592 | `OrderService/ListRecent` | 1 screen(s) |
| 593 | `OrderService/Search` | 1 screen(s) |
| 594 | `OrderService/UpdateStatus` | 1 screen(s) |
| 595 | `PackagingService/RunQA` | 1 screen(s) |
| 596 | `PerformanceService/GetWeeklyReport` | 1 screen(s) |
| 597 | `PlatformRulesService/Get` | 2 screen(s) |
| 598 | `PlatformService/GetAggregatedStats` | 1 screen(s) |
| 599 | `PlatformService/SyncStats` | 1 screen(s) |
| 600 | `ProductService/Archive` | 2 screen(s) |
| 601 | `ProductService/BulkArchive` | 1 screen(s) |
| 602 | `ProductService/Create` | 1 screen(s) |
| 603 | `ProductService/Delete` | 1 screen(s) |
| 604 | `ProductService/Get` | 2 screen(s) |
| 605 | `ProductService/GetLinkedContent` | 1 screen(s) |
| 606 | `ProductService/GetRank` | 1 screen(s) |
| 607 | `ProductService/GetReviews` | 1 screen(s) |
| 608 | `ProductService/GetSalesChart` | 1 screen(s) |
| 609 | `ProductService/GetSalesStats` | 1 screen(s) |
| 610 | `ProductService/GetStats` | 1 screen(s) |
| 611 | `ProductService/LinkContent` | 1 screen(s) |
| 612 | `ProductService/List` | 6 screen(s) |
| 613 | `ProductService/Search` | 3 screen(s) |
| 614 | `ProductService/SetAlertThreshold` | 1 screen(s) |
| 615 | `ProductService/UpdateStock` | 1 screen(s) |
| 616 | `ProfitService/ExportReport` | 2 screen(s) |
| 617 | `ProfitService/ExportTaxReport` | 1 screen(s) |
| 618 | `ProfitService/ExportToSheets` | 1 screen(s) |
| 619 | `ProfitService/GenerateReport` | 1 screen(s) |
| 620 | `ProfitService/GetCostBreakdown` | 1 screen(s) |
| 621 | `ProfitService/GetReportTemplates` | 1 screen(s) |
| 622 | `ProfitService/GetRevenueByPlatform` | 1 screen(s) |
| 623 | `ProfitService/GetRevenueByProduct` | 1 screen(s) |
| 624 | `ProfitService/GetSavedReports` | 1 screen(s) |
| 625 | `ProfitService/GetSummary` | 3 screen(s) |
| 626 | `ProfitService/GetTrend` | 1 screen(s) |
| 627 | `ProofService/ExportBundle` | 1 screen(s) |
| 628 | `ProofService/ExportFull` | 1 screen(s) |
| 629 | `ProofService/GetBundles` | 1 screen(s) |
| 630 | `ProofService/UploadEvidence` | 1 screen(s) |
| 631 | `PublishService/Cancel` | 2 screen(s) |
| 632 | `PublishService/CheckCompatibility` | 1 screen(s) |
| 633 | `PublishService/Delete` | 2 screen(s) |
| 634 | `PublishService/Duplicate` | 1 screen(s) |
| 635 | `PublishService/Execute` | 4 screen(s) |
| 636 | `PublishService/Get` | 2 screen(s) |
| 637 | `PublishService/GetCalendar` | 1 screen(s) |
| 638 | `PublishService/GetCrossPostInsights` | 1 screen(s) |
| 639 | `PublishService/GetDiagnostics` | 1 screen(s) |
| 640 | `PublishService/GetDraft` | 2 screen(s) |
| 641 | `PublishService/GetLogs` | 1 screen(s) |
| 642 | `PublishService/GetPlatformStatus` | 1 screen(s) |
| 643 | `PublishService/HoldSchedule` | 1 screen(s) |
| 644 | `PublishService/List` | 2 screen(s) |
| 645 | `PublishService/ListByDateRange` | 2 screen(s) |
| 646 | `PublishService/ListDrafts` | 1 screen(s) |
| 647 | `PublishService/ListPosts` | 1 screen(s) |
| 648 | `PublishService/ListPublished` | 1 screen(s) |
| 649 | `PublishService/ListQueue` | 1 screen(s) |
| 650 | `PublishService/ListUpcoming` | 1 screen(s) |
| 651 | `PublishService/Pause` | 1 screen(s) |
| 652 | `PublishService/PublishNow` | 2 screen(s) |
| 653 | `PublishService/PublishVariants` | 1 screen(s) |
| 654 | `PublishService/Reschedule` | 4 screen(s) |
| 655 | `PublishService/Retry` | 4 screen(s) |
| 656 | `PublishService/SaveDraft` | 1 screen(s) |
| 657 | `PublishService/Schedule` | 3 screen(s) |
| 658 | `PublishService/ScheduleRetry` | 1 screen(s) |
| 659 | `PublishService/TagProduct` | 1 screen(s) |
| 660 | `PublishService/UntagProduct` | 1 screen(s) |
| 661 | `PublishService/UpdateDraft` | 1 screen(s) |
| 662 | `PublishService/UpdateMetadata` | 1 screen(s) |
| 663 | `QueueService/Cancel` | 1 screen(s) |
| 664 | `QueueService/GetSummary` | 1 screen(s) |
| 665 | `QueueService/List` | 1 screen(s) |
| 666 | `QueueService/ListActive` | 1 screen(s) |
| 667 | `QueueService/ListCompleted` | 1 screen(s) |
| 668 | `QueueService/ListFailed` | 1 screen(s) |
| 669 | `QueueService/ListHistory` | 1 screen(s) |
| 670 | `QueueService/Pause` | 1 screen(s) |
| 671 | `QueueService/Resume` | 1 screen(s) |
| 672 | `QueueService/Retry` | 1 screen(s) |
| 673 | `QuickEditService/SaveDraft` | 1 screen(s) |
| 674 | `RBACService/CreateCustomRole` | 1 screen(s) |
| 675 | `RBACService/GetPermissionMatrix` | 1 screen(s) |
| 676 | `RateCardService/CompareScope` | 2 screen(s) |
| 677 | `RateCardService/DeleteItem` | 1 screen(s) |
| 678 | `RateCardService/GetRateCard` | 1 screen(s) |
| 679 | `RateCardService/Reorder` | 1 screen(s) |
| 680 | `RateCardService/Save` | 1 screen(s) |
| 681 | `ReconciliationService/ApproveAll` | 1 screen(s) |
| 682 | `ReconciliationService/ApproveMatched` | 1 screen(s) |
| 683 | `ReconciliationService/Assign` | 1 screen(s) |
| 684 | `ReconciliationService/Confirm` | 1 screen(s) |
| 685 | `ReconciliationService/ConfirmWithDiscrepancy` | 1 screen(s) |
| 686 | `ReconciliationService/FlagDispute` | 2 screen(s) |
| 687 | `ReconciliationService/GetBatches` | 1 screen(s) |
| 688 | `ReconciliationService/GetStatus` | 1 screen(s) |
| 689 | `ReconciliationService/GetSuggestions` | 1 screen(s) |
| 690 | `ReconciliationService/ListPending` | 1 screen(s) |
| 691 | `ReconciliationService/ManualMatch` | 1 screen(s) |
| 692 | `ReconciliationService/RejectMatch` | 1 screen(s) |
| 693 | `ReconciliationService/Resolve` | 1 screen(s) |
| 694 | `ReconciliationService/Skip` | 1 screen(s) |
| 695 | `ReconciliationService/stream` | 1 screen(s) |
| 696 | `ReferenceService/Save` | 1 screen(s) |
| 697 | `ReferralService/GetDashboard` | 1 screen(s) |
| 698 | `ReferralService/GetReferralLink` | 1 screen(s) |
| 699 | `ReferralService/GetStats` | 1 screen(s) |
| 700 | `ReferralService/ListReferrals` | 1 screen(s) |
| 701 | `ReferralService/SendReminder` | 1 screen(s) |
| 702 | `RefundService/Approve` | 2 screen(s) |
| 703 | `RefundService/GetStats` | 1 screen(s) |
| 704 | `RefundService/List` | 1 screen(s) |
| 705 | `RefundService/Reject` | 2 screen(s) |
| 706 | `ReportService/ExportPartnershipReport` | 1 screen(s) |
| 707 | `RevenueService/ExportPDF` | 1 screen(s) |
| 708 | `RevenueService/GetRevenue` | 1 screen(s) |
| 709 | `ReviewService/AddComment` | 1 screen(s) |
| 710 | `ReviewService/ReplyComment` | 1 screen(s) |
| 711 | `SampleService/Approve` | 1 screen(s) |
| 712 | `SampleService/Cancel` | 1 screen(s) |
| 713 | `SampleService/Create` | 2 screen(s) |
| 714 | `SampleService/Decline` | 1 screen(s) |
| 715 | `SampleService/ExportReport` | 1 screen(s) |
| 716 | `SampleService/ExtendDeadline` | 1 screen(s) |
| 717 | `SampleService/GetReviewRevenue` | 1 screen(s) |
| 718 | `SampleService/GetStats` | 1 screen(s) |
| 719 | `SampleService/GetSummary` | 1 screen(s) |
| 720 | `SampleService/LinkReview` | 1 screen(s) |
| 721 | `SampleService/List` | 2 screen(s) |
| 722 | `SampleService/MarkReceived` | 1 screen(s) |
| 723 | `SampleService/MarkShipped` | 1 screen(s) |
| 724 | `SampleService/RateCreator` | 1 screen(s) |
| 725 | `SampleService/UpdateStatus` | 1 screen(s) |
| 726 | `ScriptService/AddComment` | 1 screen(s) |
| 727 | `ScriptService/AddSection` | 1 screen(s) |
| 728 | `ScriptService/Approve` | 3 screen(s) |
| 729 | `ScriptService/Create` | 2 screen(s) |
| 730 | `ScriptService/Delete` | 2 screen(s) |
| 731 | `ScriptService/DeleteSection` | 1 screen(s) |
| 732 | `ScriptService/Duplicate` | 2 screen(s) |
| 733 | `ScriptService/Get` | 4 screen(s) |
| 734 | `ScriptService/GetBrief` | 1 screen(s) |
| 735 | `ScriptService/GetReview` | 1 screen(s) |
| 736 | `ScriptService/GetStats` | 1 screen(s) |
| 737 | `ScriptService/GetVersion` | 1 screen(s) |
| 738 | `ScriptService/List` | 1 screen(s) |
| 739 | `ScriptService/ListVersions` | 1 screen(s) |
| 740 | `ScriptService/Reject` | 2 screen(s) |
| 741 | `ScriptService/ReorderSections` | 1 screen(s) |
| 742 | `ScriptService/RequestChanges` | 2 screen(s) |
| 743 | `ScriptService/ResolveComment` | 1 screen(s) |
| 744 | `ScriptService/RestoreVersion` | 1 screen(s) |
| 745 | `ScriptService/SubmitReview` | 1 screen(s) |
| 746 | `ScriptService/Update` | 3 screen(s) |
| 747 | `ScriptService/UpdateSection` | 1 screen(s) |
| 748 | `ScriptService/update` | 1 screen(s) |
| 749 | `SearchService/Query` | 3 screen(s) |
| 750 | `SeedingService/CreateAssignment` | 1 screen(s) |
| 751 | `SeedingService/CreateCampaign` | 1 screen(s) |
| 752 | `SeedingService/Duplicate` | 1 screen(s) |
| 753 | `SeedingService/DuplicateCampaign` | 1 screen(s) |
| 754 | `SeedingService/Launch` | 1 screen(s) |
| 755 | `SeedingService/LinkContent` | 1 screen(s) |
| 756 | `SeedingService/ListAssignments` | 1 screen(s) |
| 757 | `SeedingService/ListCampaigns` | 1 screen(s) |
| 758 | `SeedingService/ListRequests` | 1 screen(s) |
| 759 | `SeedingService/MarkReceived` | 1 screen(s) |
| 760 | `SeedingService/MarkShipped` | 1 screen(s) |
| 761 | `SeedingService/RemoveAssignment` | 1 screen(s) |
| 762 | `SeedingService/SendReminder` | 1 screen(s) |
| 763 | `SeedingService/UpdateStatus` | 1 screen(s) |
| 764 | `SettingsService/Update` | 1 screen(s) |
| 765 | `SettlementService/List` | 1 screen(s) |
| 766 | `SettlementService/Upload` | 1 screen(s) |
| 767 | `SettlementService/stream` | 1 screen(s) |
| 768 | `ShipmentService/AddTracking` | 1 screen(s) |
| 769 | `ShipmentService/GetTrackingStatus` | 1 screen(s) |
| 770 | `ShippingService/GetTracking` | 1 screen(s) |
| 771 | `ShortUrlService/Generate` | 1 screen(s) |
| 772 | `SponsorInquiryService/Accept` | 1 screen(s) |
| 773 | `SponsorInquiryService/Decline` | 1 screen(s) |
| 774 | `SponsorInquiryService/Flag` | 1 screen(s) |
| 775 | `SponsorInquiryService/GetStats` | 1 screen(s) |
| 776 | `SponsorInquiryService/ListInquiries` | 1 screen(s) |
| 777 | `StoreService/CreatePage` | 1 screen(s) |
| 778 | `StoreService/DeletePage` | 1 screen(s) |
| 779 | `StoreService/DuplicatePage` | 1 screen(s) |
| 780 | `StoreService/GetPage` | 1 screen(s) |
| 781 | `StoreService/GetPageStats` | 1 screen(s) |
| 782 | `StoreService/GetThemes` | 1 screen(s) |
| 783 | `StoreService/ListPages` | 1 screen(s) |
| 784 | `StoreService/Publish` | 1 screen(s) |
| 785 | `StoreService/Unpublish` | 1 screen(s) |
| 786 | `StoreService/UpdatePage` | 1 screen(s) |
| 787 | `StudioService/Cancel` | 1 screen(s) |
| 788 | `StudioService/GetActiveJobs` | 1 screen(s) |
| 789 | `StudioService/GetModes` | 1 screen(s) |
| 790 | `StudioService/GetRecentAssets` | 1 screen(s) |
| 791 | `StudioService/Retry` | 1 screen(s) |
| 792 | `StylePackService/Create` | 1 screen(s) |
| 793 | `StylePackService/Get` | 1 screen(s) |
| 794 | `SupportService/Assign` | 1 screen(s) |
| 795 | `SupportService/CreateTicket` | 1 screen(s) |
| 796 | `SupportService/Escalate` | 1 screen(s) |
| 797 | `SupportService/GetMyTickets` | 1 screen(s) |
| 798 | `SupportService/UploadAttachment` | 1 screen(s) |
| 799 | `SyncService/GetHistory` | 1 screen(s) |
| 800 | `TaskService/AddComment` | 1 screen(s) |
| 801 | `TaskService/Complete` | 1 screen(s) |
| 802 | `TaskService/CreateTask` | 1 screen(s) |
| 803 | `TaskService/Delete` | 1 screen(s) |
| 804 | `TaskService/GetSummary` | 1 screen(s) |
| 805 | `TaskService/GetTaskComments` | 1 screen(s) |
| 806 | `TaskService/GetTaskDetail` | 1 screen(s) |
| 807 | `TaskService/ListTasks` | 2 screen(s) |
| 808 | `TaskService/Reassign` | 1 screen(s) |
| 809 | `TaskService/Snooze` | 1 screen(s) |
| 810 | `TaskService/Uncomplete` | 1 screen(s) |
| 811 | `TaskService/UpdateStatus` | 1 screen(s) |
| 812 | `TaskService/UpdateSubtask` | 1 screen(s) |
| 813 | `TaxReportService/GetReport` | 1 screen(s) |
| 814 | `TemplateService/Deploy` | 2 screen(s) |
| 815 | `TemplateService/GetFeatured` | 1 screen(s) |
| 816 | `TemplateService/GetReviews` | 1 screen(s) |
| 817 | `TemplateService/GetTemplate` | 1 screen(s) |
| 818 | `TemplateService/ListTemplates` | 2 screen(s) |
| 819 | `TemplateService/SearchTemplates` | 1 screen(s) |
| 820 | `ThreadService/AddTag` | 2 screen(s) |
| 821 | `ThreadService/Assign` | 1 screen(s) |
| 822 | `ThreadService/GetMessages` | 2 screen(s) |
| 823 | `ThreadService/GetUnreadCount` | 2 screen(s) |
| 824 | `ThreadService/List` | 1 screen(s) |
| 825 | `ThreadService/ListMobile` | 1 screen(s) |
| 826 | `ThreadService/MarkRead` | 3 screen(s) |
| 827 | `ThreadService/Mute` | 1 screen(s) |
| 828 | `ThreadService/Reply` | 1 screen(s) |
| 829 | `ThreadService/Snooze` | 1 screen(s) |
| 830 | `ThreadService/Update` | 2 screen(s) |
| 831 | `TierService/GetFeatureGates` | 1 screen(s) |
| 832 | `TokenService/GetStatus` | 1 screen(s) |
| 833 | `TrendService/Get` | 1 screen(s) |
| 834 | `TrendService/GetAudienceFit` | 1 screen(s) |
| 835 | `TrendService/GetExamples` | 1 screen(s) |
| 836 | `TrendService/GetSparklines` | 1 screen(s) |
| 837 | `TrendService/GetStats` | 1 screen(s) |
| 838 | `TrendService/GetTimeSeries` | 1 screen(s) |
| 839 | `TrendService/GetTop` | 1 screen(s) |
| 840 | `TrendService/List` | 2 screen(s) |
| 841 | `TrendService/ListRelated` | 1 screen(s) |
| 842 | `TrendService/ListTop` | 1 screen(s) |
| 843 | `TrendService/Search` | 1 screen(s) |
| 844 | `TrustService/GetScore` | 1 screen(s) |
| 845 | `UploadService/Upload` | 4 screen(s) |
| 846 | `UsageService/GetBreakdown` | 1 screen(s) |
| 847 | `UsageService/GetStorageUsage` | 1 screen(s) |
| 848 | `UserPreferencesService/Update` | 1 screen(s) |
| 849 | `UserService/InitiateAccountDeletion` | 1 screen(s) |
| 850 | `VoiceService/TestVoice` | 1 screen(s) |
| 851 | `VoiceService/UploadSample` | 1 screen(s) |
| 852 | `WatchlistService/AddItem` | 3 screen(s) |
| 853 | `WatchlistService/Create` | 2 screen(s) |
| 854 | `WatchlistService/Delete` | 1 screen(s) |
| 855 | `WatchlistService/GetItems` | 1 screen(s) |
| 856 | `WatchlistService/List` | 1 screen(s) |
| 857 | `WatchlistService/MuteItem` | 1 screen(s) |
| 858 | `WatchlistService/RemoveItem` | 2 screen(s) |
| 859 | `WatchlistService/Update` | 1 screen(s) |
| 860 | `WorkflowService/CancelRun` | 2 screen(s) |
| 861 | `WorkflowService/Clone` | 1 screen(s) |
| 862 | `WorkflowService/Delete` | 1 screen(s) |
| 863 | `WorkflowService/Disable` | 1 screen(s) |
| 864 | `WorkflowService/DismissRun` | 1 screen(s) |
| 865 | `WorkflowService/Enable` | 1 screen(s) |
| 866 | `WorkflowService/ExportRuns` | 1 screen(s) |
| 867 | `WorkflowService/Get` | 1 screen(s) |
| 868 | `WorkflowService/GetRunDetail` | 1 screen(s) |
| 869 | `WorkflowService/GetRunStats` | 2 screen(s) |
| 870 | `WorkflowService/ListRuns` | 2 screen(s) |
| 871 | `WorkflowService/ListWorkflows` | 1 screen(s) |
| 872 | `WorkflowService/ProvideInput` | 1 screen(s) |
| 873 | `WorkflowService/RetryRun` | 2 screen(s) |
| 874 | `WorkflowService/SkipStep` | 1 screen(s) |
| 875 | `WorkflowService/Test` | 1 screen(s) |
| 876 | `WorkflowService/Update` | 1 screen(s) |
| 877 | `WorkspaceService/AcceptInvite` | 1 screen(s) |
| 878 | `WorkspaceService/CancelInvite` | 2 screen(s) |
| 879 | `WorkspaceService/CompleteOnboarding` | 1 screen(s) |
| 880 | `WorkspaceService/Create` | 1 screen(s) |
| 881 | `WorkspaceService/DeclineInvite` | 1 screen(s) |
| 882 | `WorkspaceService/Delete` | 1 screen(s) |
| 883 | `WorkspaceService/Get` | 1 screen(s) |
| 884 | `WorkspaceService/GetInviteLink` | 1 screen(s) |
| 885 | `WorkspaceService/GetMemberCount` | 1 screen(s) |
| 886 | `WorkspaceService/GetPreferences` | 1 screen(s) |
| 887 | `WorkspaceService/GetUsage` | 1 screen(s) |
| 888 | `WorkspaceService/InitiateDeletion` | 1 screen(s) |
| 889 | `WorkspaceService/InviteMember` | 2 screen(s) |
| 890 | `WorkspaceService/ListInvites` | 2 screen(s) |
| 891 | `WorkspaceService/ListMembers` | 2 screen(s) |
| 892 | `WorkspaceService/ListMy` | 1 screen(s) |
| 893 | `WorkspaceService/RemoveMember` | 2 screen(s) |
| 894 | `WorkspaceService/ResendInvite` | 2 screen(s) |
| 895 | `WorkspaceService/SetActive` | 1 screen(s) |
| 896 | `WorkspaceService/SetCurrent` | 1 screen(s) |
| 897 | `WorkspaceService/SetDefaultCharacter` | 1 screen(s) |
| 898 | `WorkspaceService/SetModes` | 1 screen(s) |
| 899 | `WorkspaceService/Switch` | 1 screen(s) |
| 900 | `WorkspaceService/TransferOwnership` | 1 screen(s) |
| 901 | `WorkspaceService/Update` | 1 screen(s) |
| 902 | `WorkspaceService/UpdateMemberRole` | 2 screen(s) |
| 903 | `WorkspaceService/UpdatePreferences` | 1 screen(s) |
| 904 | `WorkspaceService/UpdateProfile` | 1 screen(s) |
| 905 | `WorkspaceService/UploadLogo` | 1 screen(s) |

---

## 2. Missing RPCs (need new API endpoints)

> These are real backend API calls referenced in screens but not defined in `api_endpoint_map.md`.
> **Action required**: Either add to API map or reclassify as UI-only.

---

## 3. UI-Only Actions (correctly not RPCs)

| # | Screen Ref | Files |
|---|---|---|
| 1 | `AdminConfigService/ToggleMaintenance` | 1 |
| 2 | `BrandDealService/ToggleDeliverable` | 1 |
| 3 | `FeatureFlagService/Toggle` | 1 |
| 4 | `LinkInBioService/ToggleLink` | 1 |
| 5 | `LiveService/ShowCoupon` | 1 |
| 6 | `ProductService/ToggleVisibility` | 1 |
| 7 | `QueueService/Hide` | 1 |
| 8 | `SupportService/Close` | 1 |

---

## 4. Services in Screens But Not in API Map

| # | Service Name | Methods Referenced | Priority |
|---|---|---|---|
---

## 5. Screen-Derived Extended RPCs (relocated from api_endpoint_map.md §10, 2026-04-06)

> **Status**: ASPIRATIONAL — NOT canonical contract definitions.
> **Source**: These RPCs were derived from screen specifications during the documentation reconciliation audit (2026-04-04).
> They represent additional UI functionality described in screen docs that extends the core services defined in `api_endpoint_map.md` §2-§9.
> They were originally placed in `api_endpoint_map.md` §10 but have been relocated here because they do NOT have canonical contract semantics (no concrete request/response shapes, verified auth requirements, or rate limits).
>
> **HUMAN_CONFIRMATION_REQUIRED**: Each row below must be dispositioned before implementation:
> 1. **Promote to canonical**: Add to `api_endpoint_map.md` with full contract semantics
> 2. **Rewrite screen doc**: Update the screen to reference an already-canonical RPC
> 3. **Defer/remove**: Mark as future/unsupported and remove from screen docs
> 4. **Reclassify as client-side**: No RPC needed (local UI state only)

### AIService

| RPC | Auth | Description |
|---|---|---|
| `AIService/AddSFX` | Editor+ | Add S F X (screen-derived) |
| `AIService/AnalyzeClips` | Editor+ | Analyze Clips (screen-derived) |
| `AIService/AnalyzeStyle` | Editor+ | Analyze Style (screen-derived) |
| `AIService/BatchSuggestReplies` | Editor+ | Batch Suggest Replies (screen-derived) |
| `AIService/BeatSync` | Editor+ | Beat Sync (screen-derived) |
| `AIService/GenerateCharacterPreview` | Editor+ | Generate Character Preview (screen-derived) |
| `AIService/GenerateLiveCueCards` | Editor+ | Generate Live Cue Cards (screen-derived) |
| `AIService/GenerateMusic` | Editor+ | Generate Music (screen-derived) |
| `AIService/GenerateThumbnails` | Editor+ | Generate Thumbnails (screen-derived) |
| `AIService/GenerateVoice` | Editor+ | Generate Voice (screen-derived) |
| `AIService/GetPricingIntelligence` | Member | Get Pricing Intelligence (screen-derived) |
| `AIService/GetProviderStatus` | Member | Get Provider Status (screen-derived) |
| `AIService/ScanBankStatement` | Editor+ | Scan Bank Statement (screen-derived) |
| `AIService/ScanReceipt` | Editor+ | Scan Receipt (screen-derived) |
| `AIService/SpeechToSong` | Editor+ | Speech To Song (screen-derived) |
| `AIService/SuggestRates` | Editor+ | Suggest Rates (screen-derived) |

### APIKeyService

| RPC | Auth | Description |
|---|---|---|
| `APIKeyService/Create` | Editor+ | Create (screen-derived) |
| `APIKeyService/GetUsageStats` | Member | Get Usage Stats (screen-derived) |
| `APIKeyService/Revoke` | Editor+ | Revoke (screen-derived) |
| `APIKeyService/Rotate` | Editor+ | Rotate (screen-derived) |
| `APIKeyService/UpdateScopes` | Editor+ | Update Scopes (screen-derived) |

### AccountService

| RPC | Auth | Description |
|---|---|---|
| `AccountService/GetStatus` | Member | Get Status (screen-derived) |

### ActivityService

| RPC | Auth | Description |
|---|---|---|
| `ActivityService/List` | Member | List (screen-derived) |

### AdminAIService

| RPC | Auth | Description |
|---|---|---|
| `AdminAIService/EstimateCost` | Editor+ | Estimate Cost (screen-derived) |
| `AdminAIService/GetConfig` | Member | Get Config (screen-derived) |
| `AdminAIService/GetPromptHistory` | Member | Get Prompt History (screen-derived) |
| `AdminAIService/GetPrompts` | Member | Get Prompts (screen-derived) |
| `AdminAIService/GetRateLimits` | Member | Get Rate Limits (screen-derived) |
| `AdminAIService/ListABTests` | Member | List A B Tests (screen-derived) |
| `AdminAIService/ListModels` | Member | List Models (screen-derived) |
| `AdminAIService/ResetPrompts` | Editor+ | Reset Prompts (screen-derived) |
| `AdminAIService/UpdateRateLimits` | Editor+ | Update Rate Limits (screen-derived) |

### AdminAbuseService

| RPC | Auth | Description |
|---|---|---|
| `AdminAbuseService/GetSLACompliance` | Member | Get S L A Compliance (screen-derived) |
| `AdminAbuseService/GetStats` | Member | Get Stats (screen-derived) |

### AdminAlertService

| RPC | Auth | Description |
|---|---|---|
| `AdminAlertService/Dismiss` | Editor+ | Dismiss (screen-derived) |
| `AdminAlertService/GetActive` | Member | Get Active (screen-derived) |

### AdminAnalyticsService

| RPC | Auth | Description |
|---|---|---|
| `AdminAnalyticsService/GetConversionFunnel` | Member | Get Conversion Funnel (screen-derived) |
| `AdminAnalyticsService/GetInsights` | Member | Get Insights (screen-derived) |

### AdminBroadcastService

| RPC | Auth | Description |
|---|---|---|
| `AdminBroadcastService/EstimateReach` | Editor+ | Estimate Reach (screen-derived) |
| `AdminBroadcastService/ListScheduled` | Member | List Scheduled (screen-derived) |

### AdminCommerceService

| RPC | Auth | Description |
|---|---|---|
| `AdminCommerceService/AddNote` | Editor+ | Add Note (screen-derived) |

### AdminComplianceService

| RPC | Auth | Description |
|---|---|---|
| `AdminComplianceService/ExportDPA` | Editor+ | Export D P A (screen-derived) |
| `AdminComplianceService/GetBreaches` | Member | Get Breaches (screen-derived) |
| `AdminComplianceService/GetDPALog` | Member | Get D P A Log (screen-derived) |
| `AdminComplianceService/GetStats` | Member | Get Stats (screen-derived) |

### AdminConfigService

| RPC | Auth | Description |
|---|---|---|
| `AdminConfigService/GetAIRates` | Member | Get A I Rates (screen-derived) |
| `AdminConfigService/GetChangeHistory` | Member | Get Change History (screen-derived) |
| `AdminConfigService/GetMaintenance` | Member | Get Maintenance (screen-derived) |
| `AdminConfigService/GetPricing` | Member | Get Pricing (screen-derived) |
| `AdminConfigService/GetRateLimits` | Member | Get Rate Limits (screen-derived) |

### AdminCreditService

| RPC | Auth | Description |
|---|---|---|
| `AdminCreditService/GetPlanAllocations` | Member | Get Plan Allocations (screen-derived) |
| `AdminCreditService/GetPoolStatus` | Member | Get Pool Status (screen-derived) |

### AdminFeeService

| RPC | Auth | Description |
|---|---|---|
| `AdminFeeService/GetHistory` | Member | Get History (screen-derived) |
| `AdminFeeService/GetRevenueStats` | Member | Get Revenue Stats (screen-derived) |
| `AdminFeeService/ListRules` | Member | List Rules (screen-derived) |

### AdminFraudService

| RPC | Auth | Description |
|---|---|---|
| `AdminFraudService/GetDeviceIntel` | Member | Get Device Intel (screen-derived) |

### AdminIncidentService

| RPC | Auth | Description |
|---|---|---|
| `AdminIncidentService/GetActive` | Member | Get Active (screen-derived) |

### AdminJobService

| RPC | Auth | Description |
|---|---|---|
| `AdminJobService/GetQueueStats` | Member | Get Queue Stats (screen-derived) |

### AdminManagementService

| RPC | Auth | Description |
|---|---|---|
| `AdminManagementService/GetSecurityOverview` | Member | Get Security Overview (screen-derived) |

### AdminRevenueService

| RPC | Auth | Description |
|---|---|---|
| `AdminRevenueService/GetComparison` | Member | Get Comparison (screen-derived) |
| `AdminRevenueService/GetPaymentHealth` | Member | Get Payment Health (screen-derived) |

### AdminService

| RPC | Auth | Description |
|---|---|---|
| `AdminService/GetAIOps` | Member | Get A I Ops (screen-derived) |
| `AdminService/GetDashboard` | Member | Get Dashboard (screen-derived) |
| `AdminService/GetRecentActivity` | Member | Get Recent Activity (screen-derived) |
| `AdminService/GetRevenueSummary` | Member | Get Revenue Summary (screen-derived) |
| `AdminService/GetSupportSummary` | Member | Get Support Summary (screen-derived) |
| `AdminService/GetSystemHealth` | Member | Get System Health (screen-derived) |
| `AdminService/GetWorkspaceStats` | Member | Get Workspace Stats (screen-derived) |
| `AdminService/ListWorkspaces` | Member | List Workspaces (screen-derived) |

### AffiliateService

| RPC | Auth | Description |
|---|---|---|
| `AffiliateService/DeleteLink` | Editor+ | Delete Link (screen-derived) |
| `AffiliateService/RenewLink` | Editor+ | Renew Link (screen-derived) |
| `AffiliateService/RunHealthCheck` | Editor+ | Run Health Check (screen-derived) |

### AlertService

| RPC | Auth | Description |
|---|---|---|
| `AlertService/GetActive` | Member | Get Active (screen-derived) |

### AnalyticsService

| RPC | Auth | Description |
|---|---|---|
| `AnalyticsService/BatchGetPostMetrics` | Member | Batch Get Post Metrics (screen-derived) |
| `AnalyticsService/GetBenchmarkData` | Member | Get Benchmark Data (screen-derived) |
| `AnalyticsService/GetBestPostingTimes` | Member | Get Best Posting Times (screen-derived) |
| `AnalyticsService/GetDashboard` | Member | Get Dashboard (screen-derived) |
| `AnalyticsService/GetTopContent` | Member | Get Top Content (screen-derived) |

### ApprovalService

| RPC | Auth | Description |
|---|---|---|
| `ApprovalService/GetQueueStats` | Member | Get Queue Stats (screen-derived) |
| `ApprovalService/ListPending` | Member | List Pending (screen-derived) |

### AssetService

| RPC | Auth | Description |
|---|---|---|
| `AssetService/AnalyzeCreativeDNA` | Editor+ | Analyze Creative D N A (screen-derived) |
| `AssetService/BatchExport` | Editor+ | Batch Export (screen-derived) |
| `AssetService/Export` | Editor+ | Export (screen-derived) |
| `AssetService/FetchReference` | Editor+ | Fetch Reference (screen-derived) |
| `AssetService/Get` | Member | Get (screen-derived) |
| `AssetService/ListMusicGenres` | Member | List Music Genres (screen-derived) |
| `AssetService/Upload` | Editor+ | Upload (screen-derived) |

### BillingService

| RPC | Auth | Description |
|---|---|---|
| `BillingService/CancelPlan` | Editor+ | Cancel Plan (screen-derived) |
| `BillingService/GetCurrentPlan` | Member | Get Current Plan (screen-derived) |
| `BillingService/GetPaymentMethods` | Member | Get Payment Methods (screen-derived) |
| `BillingService/GetSubscription` | Member | Get Subscription (screen-derived) |
| `BillingService/ListCreditPackages` | Member | List Credit Packages (screen-derived) |
| `BillingService/ListPlans` | Member | List Plans (screen-derived) |

### BrandDealService

| RPC | Auth | Description |
|---|---|---|
| `BrandDealService/GetPipelineStats` | Member | Get Pipeline Stats (screen-derived) |
| `BrandDealService/GetSummary` | Member | Get Summary (screen-derived) |

### BrandPackService

| RPC | Auth | Description |
|---|---|---|
| `BrandPackService/Create` | Editor+ | Create (screen-derived) |
| `BrandPackService/List` | Member | List (screen-derived) |
| `BrandPackService/Update` | Editor+ | Update (screen-derived) |

### BriefService

| RPC | Auth | Description |
|---|---|---|
| `BriefService/AddShot` | Editor+ | Add Shot (screen-derived) |
| `BriefService/DeleteShot` | Editor+ | Delete Shot (screen-derived) |
| `BriefService/GetSuggestedActions` | Member | Get Suggested Actions (screen-derived) |
| `BriefService/GetWarnings` | Member | Get Warnings (screen-derived) |
| `BriefService/ReorderShots` | Editor+ | Reorder Shots (screen-derived) |
| `BriefService/Update` | Editor+ | Update (screen-derived) |

### CampaignService

| RPC | Auth | Description |
|---|---|---|
| `CampaignService/Duplicate` | Editor+ | Duplicate (screen-derived) |
| `CampaignService/ExportReport` | Editor+ | Export Report (screen-derived) |

### CapabilityService

| RPC | Auth | Description |
|---|---|---|
| `CapabilityService/GetRecentIssues` | Member | Get Recent Issues (screen-derived) |
| `CapabilityService/GetSnapshots` | Member | Get Snapshots (screen-derived) |
| `CapabilityService/GetSystemStatus` | Member | Get System Status (screen-derived) |

### CharacterService

| RPC | Auth | Description |
|---|---|---|
| `CharacterService/Delete` | Editor+ | Delete (screen-derived) |

### CompetitorService

| RPC | Auth | Description |
|---|---|---|
| `CompetitorService/Add` | Editor+ | Add (screen-derived) |
| `CompetitorService/DismissSuggestion` | Editor+ | Dismiss Suggestion (screen-derived) |
| `CompetitorService/GetSuggestions` | Member | Get Suggestions (screen-derived) |

### ConnectorService

| RPC | Auth | Description |
|---|---|---|
| `ConnectorService/Check` | Editor+ | Check (screen-derived) |
| `ConnectorService/CheckRequirements` | Editor+ | Check Requirements (screen-derived) |
| `ConnectorService/CountActive` | Member | Count Active (screen-derived) |
| `ConnectorService/GetAllStatus` | Member | Get All Status (screen-derived) |
| `ConnectorService/GetSyncStatus` | Member | Get Sync Status (screen-derived) |
| `ConnectorService/GetTokenStatus` | Member | Get Token Status (screen-derived) |
| `ConnectorService/ListActive` | Member | List Active (screen-derived) |
| `ConnectorService/RefreshToken` | Editor+ | Refresh Token (screen-derived) |
| `ConnectorService/Reply` | Editor+ | Reply (screen-derived) |

### ContentService

| RPC | Auth | Description |
|---|---|---|
| `ContentService/GetCaptionStyles` | Member | Get Caption Styles (screen-derived) |
| `ContentService/GetHookTemplates` | Member | Get Hook Templates (screen-derived) |

### CouponService

| RPC | Auth | Description |
|---|---|---|
| `CouponService/Delete` | Editor+ | Delete (screen-derived) |
| `CouponService/Pause` | Editor+ | Pause (screen-derived) |
| `CouponService/Resume` | Editor+ | Resume (screen-derived) |

### DashboardService

| RPC | Auth | Description |
|---|---|---|
| `DashboardService/GetMobileHome` | Member | Get Mobile Home (screen-derived) |
| `DashboardService/GetPipeline` | Member | Get Pipeline (screen-derived) |

### DiagnosticsService

| RPC | Auth | Description |
|---|---|---|
| `DiagnosticsService/GetHealthGrid` | Member | Get Health Grid (screen-derived) |
| `DiagnosticsService/GetOverview` | Member | Get Overview (screen-derived) |
| `DiagnosticsService/ListIssues` | Member | List Issues (screen-derived) |
| `DiagnosticsService/RunFullCheck` | Editor+ | Run Full Check (screen-derived) |

### EntityService

| RPC | Auth | Description |
|---|---|---|
| `EntityService/AddNote` | Editor+ | Add Note (screen-derived) |
| `EntityService/AddTag` | Editor+ | Add Tag (screen-derived) |

### ExchangeRateService

| RPC | Auth | Description |
|---|---|---|
| `ExchangeRateService/GetRates` | Member | Get Rates (screen-derived) |

### FeatureFlagService

| RPC | Auth | Description |
|---|---|---|
| `FeatureFlagService/Archive` | Editor+ | Archive (screen-derived) |
| `FeatureFlagService/Create` | Editor+ | Create (screen-derived) |
| `FeatureFlagService/Toggle` | Editor+ | Toggle (screen-derived) |
| `FeatureFlagService/Update` | Editor+ | Update (screen-derived) |

### FileService

| RPC | Auth | Description |
|---|---|---|
| `FileService/GetMetadata` | Member | Get Metadata (screen-derived) |
| `FileService/Upload` | Editor+ | Upload (screen-derived) |

### GenerationService

| RPC | Auth | Description |
|---|---|---|
| `GenerationService/ListActive` | Member | List Active (screen-derived) |
| `GenerationService/StreamActiveJobs` | Editor+ | Stream Active Jobs (screen-derived) |

### IdeaService

| RPC | Auth | Description |
|---|---|---|
| `IdeaService/AddReference` | Editor+ | Add Reference (screen-derived) |
| `IdeaService/Update` | Editor+ | Update (screen-derived) |

### InventoryService

| RPC | Auth | Description |
|---|---|---|
| `InventoryService/BulkStockIn` | Editor+ | Bulk Stock In (screen-derived) |
| `InventoryService/CreateStockMovement` | Editor+ | Create Stock Movement (screen-derived) |
| `InventoryService/GetAlerts` | Member | Get Alerts (screen-derived) |
| `InventoryService/GetSummary` | Member | Get Summary (screen-derived) |
| `InventoryService/UpdateThresholds` | Editor+ | Update Thresholds (screen-derived) |

### KBService

| RPC | Auth | Description |
|---|---|---|
| `KBService/GetCategories` | Member | Get Categories (screen-derived) |
| `KBService/GetCategoryCounts` | Member | Get Category Counts (screen-derived) |
| `KBService/GetPopularArticles` | Member | Get Popular Articles (screen-derived) |

### LinkInBioService

| RPC | Auth | Description |
|---|---|---|
| `LinkInBioService/Reorder` | Editor+ | Reorder (screen-derived) |
| `LinkInBioService/Save` | Editor+ | Save (screen-derived) |
| `LinkInBioService/ToggleLink` | Editor+ | Toggle Link (screen-derived) |
| `LinkInBioService/UpdateTheme` | Editor+ | Update Theme (screen-derived) |

### ModelService

| RPC | Auth | Description |
|---|---|---|
| `ModelService/ListAvailable` | Member | List Available (screen-derived) |

### NotificationService

| RPC | Auth | Description |
|---|---|---|
| `NotificationService/GetQuietHours` | Member | Get Quiet Hours (screen-derived) |
| `NotificationService/GetUnreadCount` | Member | Get Unread Count (screen-derived) |
| `NotificationService/ResetPreferences` | Editor+ | Reset Preferences (screen-derived) |
| `NotificationService/SavePreferences` | Editor+ | Save Preferences (screen-derived) |
| `NotificationService/SendBriefEmail` | Editor+ | Send Brief Email (screen-derived) |

### OfferService

| RPC | Auth | Description |
|---|---|---|
| `OfferService/GetPerformance` | Member | Get Performance (screen-derived) |

### OrderService

| RPC | Auth | Description |
|---|---|---|
| `OrderService/BulkCancel` | Editor+ | Bulk Cancel (screen-derived) |
| `OrderService/BulkUpdateStatus` | Editor+ | Bulk Update Status (screen-derived) |
| `OrderService/GetTodayStats` | Member | Get Today Stats (screen-derived) |

### PlatformService

| RPC | Auth | Description |
|---|---|---|
| `PlatformService/GetAggregatedStats` | Member | Get Aggregated Stats (screen-derived) |

### ProductService

| RPC | Auth | Description |
|---|---|---|
| `ProductService/GetStats` | Member | Get Stats (screen-derived) |
| `ProductService/Search` | Editor+ | Search (screen-derived) |

### ProofService

| RPC | Auth | Description |
|---|---|---|
| `ProofService/ExportBundle` | Editor+ | Export Bundle (screen-derived) |
| `ProofService/ExportFull` | Editor+ | Export Full (screen-derived) |
| `ProofService/UploadEvidence` | Editor+ | Upload Evidence (screen-derived) |

### PublishService

| RPC | Auth | Description |
|---|---|---|
| `PublishService/CheckCompatibility` | Editor+ | Check Compatibility (screen-derived) |
| `PublishService/Get` | Member | Get (screen-derived) |
| `PublishService/GetDraft` | Member | Get Draft (screen-derived) |
| `PublishService/PublishNow` | Editor+ | Publish Now (screen-derived) |
| `PublishService/Reschedule` | Editor+ | Reschedule (screen-derived) |
| `PublishService/UpdateDraft` | Editor+ | Update Draft (screen-derived) |
| `PublishService/UpdateMetadata` | Editor+ | Update Metadata (screen-derived) |

### QueueService

| RPC | Auth | Description |
|---|---|---|
| `QueueService/GetSummary` | Member | Get Summary (screen-derived) |
| `QueueService/ListActive` | Member | List Active (screen-derived) |
| `QueueService/ListCompleted` | Member | List Completed (screen-derived) |
| `QueueService/ListFailed` | Member | List Failed (screen-derived) |

### RBACService

| RPC | Auth | Description |
|---|---|---|
| `RBACService/GetPermissionMatrix` | Member | Get Permission Matrix (screen-derived) |

### RateCardService

| RPC | Auth | Description |
|---|---|---|
| `RateCardService/DeleteItem` | Editor+ | Delete Item (screen-derived) |
| `RateCardService/Reorder` | Editor+ | Reorder (screen-derived) |
| `RateCardService/Save` | Editor+ | Save (screen-derived) |

### ReportService

| RPC | Auth | Description |
|---|---|---|
| `ReportService/ExportPartnershipReport` | Editor+ | Export Partnership Report (screen-derived) |

### RevenueService

| RPC | Auth | Description |
|---|---|---|
| `RevenueService/ExportPDF` | Editor+ | Export P D F (screen-derived) |

### ScriptService

| RPC | Auth | Description |
|---|---|---|
| `ScriptService/GetStats` | Member | Get Stats (screen-derived) |
| `ScriptService/UpdateSection` | Editor+ | Update Section (screen-derived) |

### SeedingService

| RPC | Auth | Description |
|---|---|---|
| `SeedingService/CreateAssignment` | Editor+ | Create Assignment (screen-derived) |
| `SeedingService/MarkReceived` | Editor+ | Mark Received (screen-derived) |
| `SeedingService/RemoveAssignment` | Editor+ | Remove Assignment (screen-derived) |
| `SeedingService/SendReminder` | Editor+ | Send Reminder (screen-derived) |

### SponsorInquiryService

| RPC | Auth | Description |
|---|---|---|
| `SponsorInquiryService/Accept` | Editor+ | Accept (screen-derived) |
| `SponsorInquiryService/Flag` | Editor+ | Flag (screen-derived) |
| `SponsorInquiryService/GetStats` | Member | Get Stats (screen-derived) |

### StylePackService

| RPC | Auth | Description |
|---|---|---|
| `StylePackService/Create` | Editor+ | Create (screen-derived) |

### SupportService

| RPC | Auth | Description |
|---|---|---|
| `SupportService/UploadAttachment` | Editor+ | Upload Attachment (screen-derived) |

### TemplateService

| RPC | Auth | Description |
|---|---|---|
| `TemplateService/GetFeatured` | Member | Get Featured (screen-derived) |
| `TemplateService/ListTemplates` | Member | List Templates (screen-derived) |

### ThreadService

| RPC | Auth | Description |
|---|---|---|
| `ThreadService/AddTag` | Editor+ | Add Tag (screen-derived) |
| `ThreadService/GetUnreadCount` | Member | Get Unread Count (screen-derived) |
| `ThreadService/MarkRead` | Editor+ | Mark Read (screen-derived) |
| `ThreadService/Mute` | Editor+ | Mute (screen-derived) |

### TrustService

| RPC | Auth | Description |
|---|---|---|
| `TrustService/GetScore` | Member | Get Score (screen-derived) |

### UploadService

| RPC | Auth | Description |
|---|---|---|
| `UploadService/Upload` | Editor+ | Upload (screen-derived) |

### UsageService

| RPC | Auth | Description |
|---|---|---|
| `UsageService/GetBreakdown` | Member | Get Breakdown (screen-derived) |
| `UsageService/GetStorageUsage` | Member | Get Storage Usage (screen-derived) |

### UserService

| RPC | Auth | Description |
|---|---|---|
| `UserService/InitiateAccountDeletion` | Member | Initiate Account Deletion (screen-derived) |

### WorkflowService

| RPC | Auth | Description |
|---|---|---|
| `WorkflowService/GetRunStats` | Member | Get Run Stats (screen-derived) |
| `WorkflowService/Test` | Editor+ | Test (screen-derived) |

### WorkspaceService

| RPC | Auth | Description |
|---|---|---|
| `WorkspaceService/AcceptInvite` | Editor+ | Accept Invite (screen-derived) |
| `WorkspaceService/CancelInvite` | Editor+ | Cancel Invite (screen-derived) |
| `WorkspaceService/CompleteOnboarding` | Editor+ | Complete Onboarding (screen-derived) |
| `WorkspaceService/DeclineInvite` | Editor+ | Decline Invite (screen-derived) |
| `WorkspaceService/GetMemberCount` | Member | Get Member Count (screen-derived) |
| `WorkspaceService/GetPreferences` | Member | Get Preferences (screen-derived) |
| `WorkspaceService/GetUsage` | Member | Get Usage (screen-derived) |
| `WorkspaceService/InitiateDeletion` | Editor+ | Initiate Deletion (screen-derived) |
| `WorkspaceService/ListInvites` | Member | List Invites (screen-derived) |
| `WorkspaceService/ListMy` | Member | List My (screen-derived) |
| `WorkspaceService/ResendInvite` | Editor+ | Resend Invite (screen-derived) |
| `WorkspaceService/SetModes` | Editor+ | Set Modes (screen-derived) |
| `WorkspaceService/UpdateMemberRole` | Editor+ | Update Member Role (screen-derived) |
| `WorkspaceService/UpdatePreferences` | Editor+ | Update Preferences (screen-derived) |
| `WorkspaceService/UpdateProfile` | Editor+ | Update Profile (screen-derived) |
