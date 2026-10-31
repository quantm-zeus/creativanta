// Command worker refuses to run before its canonical backend contracts are implemented.
package main

import (
	"log/slog"
	"os"
)

func main() {
	slog.Error("worker is not implemented; requires durable job lease/retry/tenant authorization P0-05")
	os.Exit(2)
}
