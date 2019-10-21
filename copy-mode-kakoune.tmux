#!/usr/bin/env bash

set -e

readonly SCRIPTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts"

tmux source "$SCRIPTS/mappings.tmux"
