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
    
    echo "${BLUE}Installing xcode command line tools...${NORMAL}"
    if ! xcode-select -p >/dev/null 2>&1; then
        xcode-select --install || true
        echo "${YELLOW}Complete the Xcode Command Line Tools installation if prompted, then rerun this script.${NORMAL}"
        return 1
    fi

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

    echo "${BLUE}Running ansible playbook in verbose mode.${NORMAL}"
    ansible-playbook -i "${SCRIPT_DIR}/hosts" "${SCRIPT_DIR}/playbook.yml" --verbose
    return 0
}

function initialise() {
    BLACK=$(tput setaf 0)
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    LIME_YELLOW=$(tput setaf 190)
    YELLOW=$(tput setaf 3)
    POWDER_BLUE=$(tput setaf 153)
    BLUE=$(tput setaf 4)
    MAGENTA=$(tput setaf 5)
    CYAN=$(tput setaf 6)
    WHITE=$(tput setaf 7)
    BOLD=$(tput bold)
    NORMAL=$(tput sgr0)
    BLINK=$(tput blink)
    REVERSE=$(tput smso)
    UNDERLINE=$(tput smul)

    # Python 2 was EoL. Apple removed the system-provided installation from macOS 11 Big Sur.
    # Use the Homebrew prefix paths so Apple Silicon and Intel both work.
    
    export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
    
    # Check if python3 is present in PATH
    if command -v python3 &> /dev/null ; then
        # Get Python version and set PYTHON_VERSION variable
        PYTHON_VERSION=$(python3 --version | awk '{print $2}')
        export PYTHON_VERSION
        echo "Python 3 is available. Version: $PYTHON_VERSION"
    else
        echo "Python 3 is not found in PATH. Please install it from https://www.python.org/downloads/."
        exit 1
    fi
    #PYTHON_VERSION=`python -c 'import sys; version=sys.version_info[:3];print("{0}.{1}.{2}".format(*version))'`
    
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

