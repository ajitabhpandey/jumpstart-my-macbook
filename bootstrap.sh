#!/bin/bash
# Bootstrap the repository without requiring git to be installed locally.
# Auto-detects the repository's default branch via the GitHub API.
# Intended usage:
#   curl -fsSL https://raw.githubusercontent.com/ajitabhpandey/jumpstart-my-macbook/HEAD/bootstrap.sh | bash

set -euo pipefail

REPO_OWNER="ajitabhpandey"
REPO_NAME="jumpstart-my-macbook"

echo "Detecting default branch for ${REPO_OWNER}/${REPO_NAME}"
# Use -sSL (not -fsSL) so HTTP errors don't cause curl to exit non-zero.
# Use grep -oE to handle the space GitHub includes after the colon in JSON.
# Append || true so a grep miss doesn't trigger set -e.
REPO_BRANCH=$(curl -sSL "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}" \
    | grep -oE '"default_branch"[[:space:]]*:[[:space:]]*"[^"]+"' \
    | sed 's/.*"\([^"]*\)"$/\1/' || true)

if [ -z "${REPO_BRANCH}" ]; then
    echo "Warning: could not detect default branch, falling back to master"
    REPO_BRANCH="master"
fi

echo "Using branch: ${REPO_BRANCH}"
ARCHIVE_URL="https://codeload.github.com/${REPO_OWNER}/${REPO_NAME}/tar.gz/refs/heads/${REPO_BRANCH}"
TEMP_DIR="$(mktemp -d)"
ARCHIVE_PATH="${TEMP_DIR}/${REPO_NAME}.tar.gz"
EXTRACTED_DIR="${TEMP_DIR}/${REPO_NAME}-${REPO_BRANCH}"

cleanup() {
    if [ -d "${TEMP_DIR}" ]; then
        rm -rf "${TEMP_DIR}"
    fi
}

trap cleanup EXIT

echo "Downloading ${REPO_OWNER}/${REPO_NAME} (${REPO_BRANCH})"
curl -fsSL "${ARCHIVE_URL}" -o "${ARCHIVE_PATH}"

echo "Extracting repository archive"
tar -xzf "${ARCHIVE_PATH}" -C "${TEMP_DIR}"

if [ ! -x "${EXTRACTED_DIR}/start.sh" ]; then
    chmod +x "${EXTRACTED_DIR}/start.sh"
fi

echo "Running bootstrap from downloaded repository"
"${EXTRACTED_DIR}/start.sh" "$@"
