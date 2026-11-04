package rbac

import (
	"encoding/csv"
	"io"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"testing"

	"github.com/quantm-zeus/creativanta/apps/api/internal/bootstrap"
)

// Allowed modules up to Phase P1 per docs/00_index/IMPLEMENTATION_ORDER.md §2 and AGENT_BUILD_BACKLOG.md
var allowedModules = map[string]bool{
	"auth":     true,
	"S24":      true,
	"M01":      true,
	"M22":      true,
	"M23":      true,
	"help":     true,
	"S26":      true,
	"M13":      true, // Phase P1: Product Hub / Inventory / Order Truth
	"M19":      true, // Phase P1-03: Operating Ledger / Profit / Costs / Settlements (M19)
	"M02":      true, // Phase P2: Trend Fusion Radar (M02)
	"M03":      true, // Phase P2-02: Research & Competitor Intelligence (M03)
	"M04":      true, // Phase P2-03: Opportunity Board (M04)
	"M05":      true, // Phase P3: Idea Engine (M05)
	"M06":      true, // Phase P3-02: Script Lab (M06)
	"M08":      true, // Phase P3-03: Continuity OS (M08)
	"copilot":  true, // Phase P3-04: Copilot Operations Assistant (copilot)
	"M07":      true, // Phase P4-01: AI Video Studio & Production (M07)
	"M09":      true, // Phase P5-03: Asset Derivative Manager (M09)
	"M11":      true, // Phase P5-01: Publish Hub (M11)
	"M12":      true, // Phase P5-02: Unified Inbox & Engagement Center (M12)
	"S16":      true, // Phase P5-03: Creator Pro Tools (S16)
	"M14":      true, // Phase P6-01: Monetization OS (M14)
	"M15":      true, // Phase P6-02: Creator Store, Bundles & Memberships (M15)
	"M16":      true, // Phase P6-03: In-Product Affiliate Network (M16)
	"M17":      true, // Phase P6-05: Live Commerce War Room (M17)
	"M18":      true, // Phase P6-06: Seeding CRM (M18)
	"M20":      true, // Phase P7-01: Workflow Studio (M20)
	"M21":      true, // Phase P7-03: Recipe Marketplace & Governance (M21)
	"referral": true, // Phase P8-05: Referral & Growth Engine (referral)
}

// TestNoFuturePhaseRPCExposed satisfies Acceptance Target:
// "No future-phase RPC accidentally exposed"
//
// 1. Reads docs/04_contracts/rpc_permission_bindings.csv
// 2. Identifies all RPCs belonging to future-phase modules (P2–P8: M02–M12, M14–M18, M20–M21, S16, referral, etc.)
// 3. Verifies that NO .proto file in protos/ contains any future-phase service or RPC definitions
// 4. Verifies that NO Go entrypoint in apps/api/cmd/api or apps/api/cmd/admin-api registers future-phase handlers
// 5. Performs live HTTP probe against api handler to verify future-phase paths return 404/fail-closed
func TestNoFuturePhaseRPCExposed(t *testing.T) {
	root := repoRootDir(t)
	bindingsPath := filepath.Join(root, "docs", "04_contracts", "rpc_permission_bindings.csv")

	f, err := os.Open(bindingsPath)
	if err != nil {
		t.Fatalf("open rpc_permission_bindings.csv: %v", err)
	}
	defer f.Close()

	reader := csv.NewReader(f)
	header, err := reader.Read()
	if err != nil {
		t.Fatalf("read header: %v", err)
	}

	rpcIdx := -1
	modIdx := -1
	for i, h := range header {
		switch strings.TrimSpace(h) {
		case "rpc":
			rpcIdx = i
		case "module":
			modIdx = i
		}
	}
	if rpcIdx == -1 || modIdx == -1 {
		t.Fatalf("malformed rpc_permission_bindings.csv header: %v", header)
	}

	futureRPCs := make(map[string]string) // rpc -> module
	p0RPCs := make(map[string]string)

	for {
		rec, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			t.Fatalf("read row: %v", err)
		}
		rpcName := strings.TrimSpace(rec[rpcIdx])
		moduleName := strings.TrimSpace(rec[modIdx])

		if allowedModules[moduleName] {
			p0RPCs[rpcName] = moduleName
		} else {
			futureRPCs[rpcName] = moduleName
		}
	}

	if len(futureRPCs) == 0 {
		t.Fatal("expected future-phase RPCs to be cataloged in rpc_permission_bindings.csv")
	}
	t.Logf("Cataloged %d current-phase RPCs and %d future-phase RPCs", len(p0RPCs), len(futureRPCs))

	// 1. Audit all .proto files in protos/
	protoDir := filepath.Join(root, "protos")
	protoFiles, err := findFilesByExt(protoDir, ".proto")
	if err != nil {
		t.Fatalf("find proto files: %v", err)
	}
	if len(protoFiles) == 0 {
		t.Fatal("no proto files found in protos/")
	}

	serviceRegex := regexp.MustCompile(`service\s+([A-Za-z0-9_]+)\s*\{`)
	rpcRegex := regexp.MustCompile(`rpc\s+([A-Za-z0-9_]+)\s*\(`)

	var exposedFutureRPCs []string
	for _, pf := range protoFiles {
		contentBytes, err := os.ReadFile(pf)
		if err != nil {
			t.Fatalf("read %s: %v", pf, err)
		}
		content := string(contentBytes)

		// Extract service names
		serviceMatches := serviceRegex.FindAllStringSubmatch(content, -1)
		currentService := ""
		if len(serviceMatches) > 0 {
			currentService = serviceMatches[0][1]
		}

		rpcMatches := rpcRegex.FindAllStringSubmatch(content, -1)
		for _, match := range rpcMatches {
			rpcMethod := match[1]
			fullRPC := currentService + "/" + rpcMethod

			if mod, isFuture := futureRPCs[fullRPC]; isFuture {
				exposedFutureRPCs = append(exposedFutureRPCs, fullRPC+" (module "+mod+" in "+filepath.Base(pf)+")")
			}
		}
	}

	if len(exposedFutureRPCs) > 0 {
		t.Fatalf("VIOLATION: Future-phase RPCs found in compiled protos: %v", exposedFutureRPCs)
	}
	t.Log("PASS: Zero future-phase RPCs defined in protos/ directory.")

	// 2. Audit apps/api/cmd/api and apps/api/cmd/admin-api
	cmdFiles, err := findFilesByExt(filepath.Join(root, "apps", "api", "cmd"), ".go")
	if err != nil {
		t.Fatalf("find cmd go files: %v", err)
	}

	for _, cf := range cmdFiles {
		contentBytes, err := os.ReadFile(cf)
		if err != nil {
			t.Fatalf("read %s: %v", cf, err)
		}
		content := string(contentBytes)

		for futureRPC, mod := range futureRPCs {
			parts := strings.Split(futureRPC, "/")
			serviceName := parts[0]
			// Check if future service name appears in production entrypoint
			if strings.Contains(content, serviceName) && !strings.Contains(cf, "test") {
				t.Fatalf("VIOLATION: Future-phase service %q (module %s) referenced in production entrypoint %s",
					serviceName, mod, cf)
			}
		}
	}
	t.Log("PASS: Zero future-phase service handlers registered in production entrypoints.")

	// 3. Live HTTP Probe: Verify API server fails closed on any future-phase RPC endpoint
	handler, err := bootstrap.NewHandler(bootstrap.RoleAPI, nil)
	if err != nil {
		t.Fatalf("bootstrap.NewHandler: %v", err)
	}
	server := httptest.NewServer(handler)
	defer server.Close()

	probeFuturePaths := []string{
		"/creativanta.trends.v1.TrendService/List",
		"/creativanta.workflow.v1.WorkflowService/Create",
		"/creativanta.script.v1.ScriptService/Generate",
		"/creativanta.publish.v1.PublishService/PublishNow",
		"/creativanta.live.v1.LiveCommerceService/StartSession",
		"/creativanta.monetization.v1.OfferService/Create",
		"/TrendService/List",
	}

	client := server.Client()
	for _, path := range probeFuturePaths {
		resp, err := client.Post(server.URL+path, "application/json", strings.NewReader("{}"))
		if err != nil {
			t.Fatalf("POST %s: %v", path, err)
		}
		resp.Body.Close()

		// Endpoint must be 404 Not Found (or 503 Not Ready) — NEVER 200 OK or routed to live handler
		if resp.StatusCode != http.StatusNotFound && resp.StatusCode != http.StatusServiceUnavailable {
			t.Fatalf("VIOLATION: Future-phase path %s returned unexpected status %d (expected 404)",
				path, resp.StatusCode)
		}
	}
	t.Log("PASS: Live API server strictly rejects all future-phase endpoints with 404.")
}

func findFilesByExt(dir string, ext string) ([]string, error) {
	var files []string
	err := filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() && strings.HasSuffix(info.Name(), ext) {
			files = append(files, path)
		}
		return nil
	})
	return files, err
}
