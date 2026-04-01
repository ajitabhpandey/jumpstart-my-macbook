#!/bin/bash
# Script to jumpstart a macbook with ansible 

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${SCRIPT_DIR}/python-venv/ansible"

function uninstall() {
    echo "${RED}WARNING : This will remove homebrew and all applications installed through it"
    echo -n "are you sure you want to do that? [y/n] : ${NORMAL}"
    read confirmation

    if [ "$confirmation" == "y" ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
        return 0
    else
        echo "Cancelling Uninstall. No changes were made"
        return 0
    fi
}

function install() {
    
    echo "${GREEN}${BOLD}========================"
    echo "Setting up the macbook"
    echo "========================${NORMAL}"
    
    echo "${BLUE}Using repository at ${SCRIPT_DIR}${NORMAL}"
    cd "${SCRIPT_DIR}"

    echo "${BLUE}Creating Python virtual environment in python-venv/ansible${NORMAL}"
    mkdir -p "${SCRIPT_DIR}/python-venv"
    python3 -m venv "${VENV_DIR}"
    # shellcheck disable=SC1091
    source "${VENV_DIR}/bin/activate"

    echo "${BLUE}Installing Ansible in the virtual environment${NORMAL}"
    python -m pip install --upgrade pip
    python -m pip install ansible
    ansible-galaxy collection install -r "${SCRIPT_DIR}/collections/requirements.yml"

    # Homebrew's installer may require sudo and cannot always prompt cleanly
    # when invoked from a non-interactive Ansible task. Prompt once here.
    echo "${BLUE}Validating sudo access for install tasks${NORMAL}"
    if ! sudo -v; then
        echo "${RED}Unable to obtain sudo credentials. Cannot continue.${NORMAL}"
        return 1
    fi

    echo "${BLUE}Running ansible playbook in verbose mode (will prompt for sudo when needed).${NORMAL}"
    ansible-playbook -i "${SCRIPT_DIR}/hosts" "${SCRIPT_DIR}/playbook.yml" --verbose --ask-become-pass
    return 0
}

function initialise() {
    # Colour setup: tput can fail in non-TTY environments (e.g. curl | bash).
    # Guard every call so set -e cannot exit the script silently.
    if [ -t 1 ] && command -v tput &>/dev/null; then
        BLACK=$(tput setaf 0 2>/dev/null || true)
        RED=$(tput setaf 1 2>/dev/null || true)
        GREEN=$(tput setaf 2 2>/dev/null || true)
        LIME_YELLOW=$(tput setaf 190 2>/dev/null || true)
        YELLOW=$(tput setaf 3 2>/dev/null || true)
        POWDER_BLUE=$(tput setaf 153 2>/dev/null || true)
        BLUE=$(tput setaf 4 2>/dev/null || true)
        MAGENTA=$(tput setaf 5 2>/dev/null || true)
        CYAN=$(tput setaf 6 2>/dev/null || true)
        WHITE=$(tput setaf 7 2>/dev/null || true)
        BOLD=$(tput bold 2>/dev/null || true)
        NORMAL=$(tput sgr0 2>/dev/null || true)
        BLINK=$(tput blink 2>/dev/null || true)
        REVERSE=$(tput smso 2>/dev/null || true)
        UNDERLINE=$(tput smul 2>/dev/null || true)
    else
        BLACK=''; RED=''; GREEN=''; LIME_YELLOW=''; YELLOW=''
        POWDER_BLUE=''; BLUE=''; MAGENTA=''; CYAN=''; WHITE=''
        BOLD=''; NORMAL=''; BLINK=''; REVERSE=''; UNDERLINE=''
    fi

    # Use the Homebrew prefix paths so Apple Silicon and Intel both work.
    export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

    # Xcode Command Line Tools must be present before python3 is available.
    # Check here so the error message is meaningful on a fresh Mac.
    if ! xcode-select -p >/dev/null 2>&1; then
        echo "Xcode Command Line Tools not found. Triggering installation..."
        xcode-select --install 2>/dev/null || true
        echo ""
        echo "A dialog has appeared asking you to install the Command Line Tools."
        echo "Complete that installation, then rerun this script."
        exit 0
    fi

    # Check if python3 is present in PATH (provided by Xcode CLT on a fresh Mac).
    if command -v python3 &>/dev/null; then
        PYTHON_VERSION=$(python3 --version | awk '{print $2}')
        export PYTHON_VERSION
        echo "Python 3 is available. Version: $PYTHON_VERSION"
    else
        echo "Python 3 is not found in PATH. Please install Xcode Command Line Tools first."
        exit 1
    fi
}

function cleanup() {
    echo "${YELLOW}Cleaning up....${NORMAL}"
    echo "${YELLOW}Deactivating virtualenv if being used${NORMAL}"
    if [ -n "${VIRTUAL_ENV:-}" ]; then
        deactivate
    fi
    echo "${YELLOW}${BLINK}Cleanup complete. Please handle any error manually...${NORMAL}"
    return
}


function main() {
    local EXIT_VAL=0
    local ACTION="${1:-}"
    # initialization
    initialise
    echo "${BLUE}Initialisation complete.${NORMAL}"

    if [ "${ACTION}" == "uninstall" ]
    then
        uninstall
        cleanup
        exit 0
    fi

    if install
    then
        echo "${GREEN}Installed successfully${NORMAL}"
    else
        echo "${RED}Install Failed${NORMAL}"
        EXIT_VAL=1
    fi
    cleanup
    exit ${EXIT_VAL}
}


# set a trap for cleanup all before process termination by SIGHUBs
trap "cleanup; exit 1" 1 2 3 13 15

# call the main executable function
main "$@"

