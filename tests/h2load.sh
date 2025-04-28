#!/bin/bash

# ----------------------------------------------------------------------------------------------------------------------
# h2load - HTTP/2 load testing tool
#
# Params:
#   $1 - Number of requests to perform (default: 1000)
#   $2 - Number of concurrent clients (default: 1)
#   $3 - URL to test (default: http://example.local:8080/app)
# ----------------------------------------------------------------------------------------------------------------------
h2load() {
    local n="${1:-1000}"
    local c="${2:-1}"
    local url="${3:-http://example.local:8080/app}"
    command h2load -n "$n" -c "$c" "$url"
}

h2load "$1" "$2" "$3"
