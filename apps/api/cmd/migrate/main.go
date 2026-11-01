// Command migrate refuses to run before its canonical backend contracts are implemented.
package main

import (
	"log/slog"
	"os"
)

func main() {
	slog.Error("migrate is not implemented; requires separate migration identity, Goose schema and D2 role tests P0-04")
	os.Exit(2)
}
