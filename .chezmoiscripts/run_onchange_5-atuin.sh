#!/bin/bash

set -eufo pipefail

# Magical shell history: https://github.com/atuinsh/atuin
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
# https://docs.atuin.sh/guide/sync/
