#!/usr/bin/env bash

set -x
set -e

ROOT=$(git rev-parse --show-toplevel)
cd "${ROOT}"

# Get the path to the "nix" worktree
NIX_WORKTREE=$(git worktree list | grep '\[nix\]' | cut -d' ' -f 1)

if [ ! -d "${NIX_WORKTREE}" ]; then
    echo "nix worktree not found" >2
    exit 1
fi

# Create the links
ln -s "${NIX_WORKTREE}/shell.nix" "${ROOT}/shell.nix"
ln -s "${NIX_WORKTREE}/envrc"     "${ROOT}/.envrc"
ln -s "${NIX_WORKTREE}/postgres"  "${ROOT}/script/postgres"

# Ignore the .ignore, *.nix and .envrc files throughout the repo
if [ -f "${ROOT}/.git/info/exclude" ]; then
    cat <<EOF >> "${ROOT}/.git/info/exclude"
# Ignore nix files
**/.envrc
**/*.nix
**/.ignore/
# Ignore postgres scripts
/script/postgres
EOF
fi
