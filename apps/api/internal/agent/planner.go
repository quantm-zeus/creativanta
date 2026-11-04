package agent

import (
	"fmt"
	"strings"
)

// Planner generates discrete, audited multi-step execution plans for agent runs.
type Planner struct{}

func NewPlanner() *Planner {
	return &Planner{}
}

// PlanVideoAgent generates the 1-click video pipeline per M07 EF-08.
// Pipeline stages:
//  1. Script generation (M06) - 5 credits
//  2. Scene planning (M07) - 2 credits
//  3. Visual generation (M07) - 25 cr (Standard) or 45 cr (Premium)
//  4. Voice-over synthesis (M07) - 8 credits
//  5. Music & SFX composition (M07) - 5 credits
//  6. Assembly & final video export (M07) - 5 credits
//
// Total budget ceiling: 50 credits (Standard) or 80 credits (Premium).
func (p *Planner) PlanVideoAgent(prompt string, options map[string]string) ([]AgentStep, string, string) {
	isPremium := strings.EqualFold(options["quality"], "premium")
	visualCredits := "25.000000"
	totalCredits := "50.000000"
	if isPremium {
		visualCredits = "45.000000"
		totalCredits = "80.000000"
	}

	character := options["character"]
	if character == "" {
		character = "Default Avatar"
	}
	brandPack := options["brand_pack"]
	platform := options["platform"]
	if platform == "" {
		platform = "tiktok"
	}

	steps := []AgentStep{
		{
			StepOrder:          1,
			Phase:              StatePlanning,
			Title:              "Script Generation",
			Status:             StepStatusPlanning,
			ExpectedOutcome:    fmt.Sprintf("AI generates optimized 3-hook script for %s target (%s)", platform, prompt),
			RequiredPermission: "script:write",
			RequiredCapability: "ai.nlu",
			IsHighRisk:         false,
			EstimatedCredits:   "5.000000",
			ActualCredits:      "0.000000",
			InputContextJSON:   fmt.Sprintf(`{"prompt":%q,"brand_pack":%q,"platform":%q}`, prompt, brandPack, platform),
		},
		{
			StepOrder:          2,
			Phase:              StatePlanning,
			Title:              "Scene Planning & Visual Prompting",
			Status:             StepStatusPlanning,
			ExpectedOutcome:    "Storyboard decomposition into 5 coherent visual scenes with character anchor",
			RequiredPermission: "asset:read",
			RequiredCapability: "ai.vision",
			IsHighRisk:         false,
			EstimatedCredits:   "2.000000",
			ActualCredits:      "0.000000",
			InputContextJSON:   fmt.Sprintf(`{"character":%q}`, character),
		},
		{
			StepOrder:          3,
			Phase:              StatePlanning,
			Title:              "Visual Generation",
			Status:             StepStatusPlanning,
			ExpectedOutcome:    fmt.Sprintf("Generate 5 high-fidelity video scenes with %s character consistency", character),
			RequiredPermission: "asset:generate",
			RequiredCapability: "media.generation",
			IsHighRisk:         false,
			EstimatedCredits:   visualCredits,
			ActualCredits:      "0.000000",
			InputContextJSON:   fmt.Sprintf(`{"quality":%q}`, options["quality"]),
		},
		{
			StepOrder:          4,
			Phase:              StatePlanning,
			Title:              "Voice-Over Synthesis",
			Status:             StepStatusPlanning,
			ExpectedOutcome:    fmt.Sprintf("Generate natural narration using %s voice profile", character),
			RequiredPermission: "asset:generate",
			RequiredCapability: "media.tts",
			IsHighRisk:         false,
			EstimatedCredits:   "8.000000",
			ActualCredits:      "0.000000",
		},
		{
			StepOrder:          5,
			Phase:              StatePlanning,
			Title:              "Music & SFX Composition",
			Status:             StepStatusPlanning,
			ExpectedOutcome:    "Select and synchronize trending background music and transition SFX",
			RequiredPermission: "asset:generate",
			RequiredCapability: "media.sound",
			IsHighRisk:         false,
			EstimatedCredits:   "5.000000",
			ActualCredits:      "0.000000",
		},
		{
			StepOrder:          6,
			Phase:              StatePlanning,
			Title:              "Assembly & Export",
			Status:             StepStatusPlanning,
			ExpectedOutcome:    "Composite video, audio, captions, auto-thumbnail, and render publish-ready MP4",
			RequiredPermission: "asset:generate",
			RequiredCapability: "media.render",
			IsHighRisk:         false,
			EstimatedCredits:   "5.000000",
			ActualCredits:      "0.000000",
		},
	}

	planSummary := fmt.Sprintf("1-Click Video Pipeline: %d steps for prompt %q. Total estimated: %s credits.", len(steps), prompt, totalCredits)
	return steps, totalCredits, planSummary
}

// PlanCopilotAction generates a cross-module action chain per Copilot §5.3 and EC-COP-002.
// Steps:
//  1. Pull product info from M13 - 0 credits
//  2. Generate sales script in M06 - 5 credits
//  3. Generate showcase video in M07 - 20 credits
//  4. Create promotional thumbnail in M10 - 5 credits
//  5. (Optional) Publish to platform channel in M11 - 0 credits, High-Risk (requires Manager+ approval!)
func (p *Planner) PlanCopilotAction(prompt string, includePublish bool) ([]AgentStep, string, string) {
	steps := []AgentStep{
		{
			StepOrder:          1,
			Phase:              StatePlanning,
			Title:              "Pull Product Information (M13)",
			Status:             StepStatusPlanning,
			ExpectedOutcome:    "Extract product catalog specs, price, SKU inventory, and unique selling propositions",
			RequiredPermission: "product:read",
			RequiredCapability: "commerce.catalog",
			IsHighRisk:         false,
			EstimatedCredits:   "0.000000",
			ActualCredits:      "0.000000",
			InputContextJSON:   fmt.Sprintf(`{"query":%q}`, prompt),
		},
		{
			StepOrder:          2,
			Phase:              StatePlanning,
			Title:              "Generate Sales Script (M06)",
			Status:             StepStatusPlanning,
			ExpectedOutcome:    "Draft persuasive TikTok/Shopee video script with viral hook and CTA",
			RequiredPermission: "script:write",
			RequiredCapability: "ai.nlu",
			IsHighRisk:         false,
			EstimatedCredits:   "5.000000",
			ActualCredits:      "0.000000",
		},
		{
			StepOrder:          3,
			Phase:              StatePlanning,
			Title:              "Generate Showcase Video (M07)",
			Status:             StepStatusPlanning,
			ExpectedOutcome:    "Synthesize video assets and character voiceover showcase",
			RequiredPermission: "asset:generate",
			RequiredCapability: "media.generation",
			IsHighRisk:         false,
			EstimatedCredits:   "20.000000",
			ActualCredits:      "0.000000",
		},
		{
			StepOrder:          4,
			Phase:              StatePlanning,
			Title:              "Generate Thumbnail (M10)",
			Status:             StepStatusPlanning,
			ExpectedOutcome:    "High-CTR thumbnail candidate with prominent text overlay",
			RequiredPermission: "asset:generate",
			RequiredCapability: "media.image",
			IsHighRisk:         false,
			EstimatedCredits:   "5.000000",
			ActualCredits:      "0.000000",
		},
	}

	totalCredits := "30.000000"

	if includePublish {
		steps = append(steps, AgentStep{
			StepOrder:          5,
			Phase:              StatePlanning,
			Title:              "Publish Video to Channel (M11)",
			Status:             StepStatusPlanning,
			ExpectedOutcome:    "Dispatch publish job to linked platform channel",
			RequiredPermission: "publish:item_manage",
			RequiredCapability: "publish.channel",
			IsHighRisk:         true, // High-risk action: requires Manager+ approval gate per RULE-M21-004
			EstimatedCredits:   "0.000000",
			ActualCredits:      "0.000000",
		})
	}

	planSummary := fmt.Sprintf("Copilot Multi-Step Action Chain: %d steps for %q. Estimated credits: %s.", len(steps), prompt, totalCredits)
	return steps, totalCredits, planSummary
}

// PlanGeneric generates sequential steps for standard recipe/task prompts.
func (p *Planner) PlanGeneric(prompt string, budgetCeiling string) ([]AgentStep, string, string) {
	if budgetCeiling == "" {
		budgetCeiling = "20.000000"
	}
	steps := []AgentStep{
		{
			StepOrder:          1,
			Phase:              StatePlanning,
			Title:              "Analyze Task Requirements",
			Status:             StepStatusPlanning,
			ExpectedOutcome:    "Deconstruct prompt into discrete domain operations",
			RequiredPermission: "workflow:read",
			IsHighRisk:         false,
			EstimatedCredits:   "2.000000",
			ActualCredits:      "0.000000",
		},
		{
			StepOrder:          2,
			Phase:              StatePlanning,
			Title:              "Execute Domain Operation",
			Status:             StepStatusPlanning,
			ExpectedOutcome:    fmt.Sprintf("Perform requested task: %s", prompt),
			RequiredPermission: "script:write",
			IsHighRisk:         false,
			EstimatedCredits:   "10.000000",
			ActualCredits:      "0.000000",
		},
		{
			StepOrder:          3,
			Phase:              StatePlanning,
			Title:              "Audit and Synthesize Results",
			Status:             StepStatusPlanning,
			ExpectedOutcome:    "Package outputs, compile observation memory, and prepare review bundle",
			RequiredPermission: "workflow:read",
			IsHighRisk:         false,
			EstimatedCredits:   "3.000000",
			ActualCredits:      "0.000000",
		},
	}
	planSummary := fmt.Sprintf("Generic Agent Plan: 3 steps for task %q.", prompt)
	return steps, budgetCeiling, planSummary
}
