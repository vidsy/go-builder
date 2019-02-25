package main

import (
	"log"

	"github.com/pkg/errors"
)

var (
	// BuildTime time at which the binary was built.
	BuildTime string

	// Version the tagged version of the binary.
	Version string
)

func main() {
	log.Printf("Version: %s", Version)
	log.Printf("BuildTime: %s", BuildTime)

	if BuildTime == "" || Version == "" {
		log.Fatal(
			errors.New("Expected Version and BuildTime to be set"),
		)
	}
}
