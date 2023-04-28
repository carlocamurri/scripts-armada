#!/bin/sh

demo_file="../scripts-armada/demo.yaml"

if [ -n "$1" ]; then
    demo_file="$1"
fi

go run ./cmd/armada-load-tester/main.go loadtest "$demo_file"
