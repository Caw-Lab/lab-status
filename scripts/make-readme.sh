#!/usr/bin/env bash
# Prints README.md for Caw-Lab/lab-status to stdout.
# Usage: bash scripts/make-readme.sh <path to a clone of Caw-Lab/Caw that has the lab branch>
# Upstream PR numbers come from lab merge commits named "Merge pull request #X from <owner>/upstream-N".
set -euo pipefail

repo="$1"
head=$(git -C "$repo" rev-parse --short=8 lab)
head_date=$(git -C "$repo" log -1 --format=%cs lab)

list=$(git -C "$repo" log lab --merges --format='%s' \
  | grep -oE 'from [^/ ]+/upstream-[0-9]+' \
  | grep -oE '[0-9]+$' \
  | sort -n -u \
  | sed 's|^|- GilgameshCaw/Caw#|')

count=$(printf '%s\n' "$list" | grep -c . || true)

cat <<EOF
# Caw-Lab lab node

**lab.tencaw-node.com is an unofficial lab node run by Caw-Lab members. It is not run by the maintainer of GilgameshCaw/Caw.**

## What it is

- It runs the master branch of [GilgameshCaw/Caw](https://github.com/GilgameshCaw/Caw) plus pull requests that were submitted to that repository (listed below).
- Its purpose is to test those pull requests on a live node. What we learn goes back to GilgameshCaw/Caw as reviews and pull requests.
- It is connected to the testnet contracts only. No real CAW or mainnet assets are involved.

## What it is not

- It is not a separate product, and it is not meant to replace the upstream project.
- The lab source repository is private. This page does not publish or relicense any code. Rights to the code remain with its authors.

## If the maintainer objects

If the maintainer of GilgameshCaw/Caw objects to this node, we will stop it.

## Upstream pull requests applied

${count} pull requests, as of lab branch commit ${head} (${head_date}). This list is updated automatically.

${list}
EOF
