package main

import (
	"log"
	"os"
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
		log.Printf("Expected Version and BuildTime to be set")
		os.Exit(1)
	}
}
