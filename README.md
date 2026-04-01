# jumpstart-my-macbook

Bootstrap a macOS development machine with Ansible and Homebrew.

The bootstrap script creates a local Python virtual environment in python-venv/ansible and installs Ansible there. This keeps the system Python clean and works on current macOS releases, including Apple Silicon.

The package lists are grouped by purpose in group_vars/macbook.yml, and Ansible collections are pinned in collections/requirements.yml.

## Setup

### First run on a fresh Mac

On a brand-new Mac with no developer tools installed, the bootstrap script will detect that Xcode Command Line Tools are missing and trigger the system installation dialog. **The script will exit after that point.** Once the Xcode Command Line Tools installation has finished, rerun the exact same command to continue with the rest of the bootstrap.

### Option 1: Run without cloning first

If you want a one-shot bootstrap and do not want to install or use git first, run:

```bash
curl -fsSL https://raw.githubusercontent.com/ajitabhpandey/jumpstart-my-macbook/HEAD/bootstrap.sh | bash
```

This downloads the repository archive to a temporary directory and then runs the normal bootstrap script from there.

### Option 2: Clone the repository and run locally

If you want to rerun the playbook later or keep the local Ansible environment around, clone the repository and run:

```bash
./start.sh
```

The bootstrap process will:

- install Xcode Command Line Tools if needed
- create python-venv/ansible
- install Ansible into that virtual environment
- prompt once for your local sudo password to cache credentials for Homebrew installation
- run the playbook from either the checked out repository or a temporary downloaded copy

If you cloned the repository and want to activate the Ansible environment manually:

```bash
source python-venv/ansible/bin/activate
```

To run the playbook directly with the local virtual environment:

```bash
source python-venv/ansible/bin/activate
ansible-galaxy collection install -r collections/requirements.yml
ansible-playbook -v -i ./hosts playbook.yml --ask-become-pass
```

If the playbook breaks in between and you want to skip install tasks:

```bash
ansible-playbook -v -i ./hosts playbook.yml --skip-tags install --ask-become-pass
```

Multiple tags can be specified with a comma.

If you only want the cask tasks:

```bash
ansible-playbook -v -i ./hosts playbook.yml --tags cask-apps  --ask-become-pass
```

The package lists are maintained in [group_vars/macbook.yml](/Users/a0p011z/repos/jumpstart-my-macbook/group_vars/macbook.yml).
The Ansible collection requirements are maintained in [collections/requirements.yml](/Users/a0p011z/repos/jumpstart-my-macbook/collections/requirements.yml).
The current package rationale is documented in [docs/packages.md](/Users/a0p011z/repos/jumpstart-my-macbook/docs/packages.md).

## Notes

- The playbook now uses UTM and OrbStack instead of VirtualBox, Vagrant, and Docker Desktop for a more current Apple Silicon-friendly workflow.
- Homebrew can live in /opt/homebrew on Apple Silicon or /usr/local on Intel. The playbook checks both locations.
- The Homebrew Ansible modules come from the community.general collection declared in collections/requirements.yml.

## Uninstall

If you want to remove Homebrew and the applications installed through it from a local checkout, run:

```bash
./start.sh uninstall
```

If you are using the curl-based bootstrap flow:

```bash
curl -fsSL https://raw.githubusercontent.com/ajitabhpandey/jumpstart-my-macbook/HEAD/bootstrap.sh | bash -s -- uninstall
```
