// Command outbox refuses to run before its canonical backend contracts are implemented.
package main

import (
	"log/slog"
	"os"
)

func main() {
	slog.Error("outbox is not implemented; requires PostgreSQL outbox schema and narrow poller role P0-05")
	os.Exit(2)
}
