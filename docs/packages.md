# Package Choices

This document summarizes the Homebrew formulas and casks included in this repository and why they are useful on a current macOS development machine.

## Homebrew formulas

### Shell and core CLI

- zoxide: smarter directory jumping based on frecency. Useful replacement for autojump. Homepage: https://github.com/ajeetdsouza/zoxide
- zsh: interactive shell. Homepage: https://www.zsh.org/
- git: distributed version control. Homepage: https://git-scm.com/
- tree: directory tree viewer. Homepage: https://oldmanprogrammer.net/source.php?dir=projects/tree
- httpie: user-friendly HTTP client for APIs. Homepage: https://httpie.io/
- curl: transfer data over URLs. Homepage: https://curl.se/
- wget: non-interactive network downloader. Homepage: https://www.gnu.org/software/wget/
- ripgrep: fast recursive search tool. Preferred over ag in modern toolchains. Homepage: https://github.com/BurntSushi/ripgrep
- universal-ctags: maintained ctags implementation for code navigation. Homepage: https://github.com/universal-ctags/ctags
- nmap: network scanner and diagnostics tool. Homepage: https://nmap.org/

### Cloud and infrastructure

- kubectl: Kubernetes command-line client. Homepage: https://kubernetes.io/docs/reference/kubectl/
- helm: Kubernetes package manager. Homepage: https://helm.sh/
- terraform: infrastructure as code CLI. Homepage: https://developer.hashicorp.com/terraform

### Languages and editors

- go: Go toolchain. Homepage: https://go.dev/
- vim: terminal text editor. Homepage: https://www.vim.org/
- hugo: static site generator. Homepage: https://gohugo.io/
- neovim: modern Vim-based editor. Homepage: https://neovim.io/
- node: Node.js runtime and package ecosystem. Homepage: https://nodejs.org/
- python: Python 3 runtime. Homepage: https://www.python.org/
- php: PHP runtime. Homepage: https://www.php.net/

### Media utilities

- ffmpeg: media conversion toolkit. Homepage: https://ffmpeg.org/
- imagemagick: image manipulation tools. Homepage: https://imagemagick.org/

## Homebrew casks

### Terminals and browsers

- warp: modern terminal emulator. Homepage: https://www.warp.dev/
- iterm2: feature-rich terminal for macOS. Homepage: https://iterm2.com/
- firefox: web browser. Homepage: https://www.mozilla.org/firefox/
- google-chrome: web browser. Homepage: https://www.google.com/chrome/

### System tools

- amphetamine: prevents sleep and display idle when needed. Replacement for caffeine. Homepage: https://apps.apple.com/app/amphetamine/id937984704
- bitwarden: password manager. Replacement for LastPass. Homepage: https://bitwarden.com/
- dropbox: file synchronization client. Homepage: https://www.dropbox.com/
- visual-studio-code: code editor and IDE. Homepage: https://code.visualstudio.com/
- slack: team communication client. Homepage: https://slack.com/

### Virtualization

- orbstack: lightweight container and Linux VM environment for macOS, especially strong on Apple Silicon. Homepage: https://orbstack.dev/
- utm: virtualization front-end built on QEMU and Apple's virtualization stack where available. Good fit for ARM Macs. Homepage: https://mac.getutm.app/

### Media and reading

- shotcut: video editor. Homepage: https://shotcut.org/
- gimp: raster image editor. Homepage: https://www.gimp.org/
- vlc: media player. Homepage: https://www.videolan.org/vlc/
- calibre: ebook management suite. Homepage: https://calibre-ebook.com/

## Replaced with Modern Alternatives

- autojump was replaced with zoxide because zoxide is more actively maintained and widely adopted.
- ag was replaced with ripgrep because ripgrep is faster and better integrated with current developer tooling.
- ctags was replaced with universal-ctags because the original ctags package is not the preferred maintained implementation.
- Docker Desktop, Vagrant, and VirtualBox were removed in favor of OrbStack and UTM, which are a better fit for current macOS and Apple Silicon workflows.
- caffeine was replaced with amphetamine.
- lastpass was replaced with bitwarden, mostly due to high number of security issues with lastpass.