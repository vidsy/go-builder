package main

import (
	"log"
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
}
