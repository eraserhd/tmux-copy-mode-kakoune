#!/usr/bin/env bash

set -e

readonly SCRIPTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts"
tmux set-option -g '@copy_mode_kakoune_scripts' "$SCRIPTS"
tmux source "$SCRIPTS/mappings.tmux"
