# emacs

A personal Emacs config with evil, org, magit, gruvbox, JetBrains Mono and a dashboard start screen. It runs on Linux, macOS, Windows and NixOS, and nothing needs admin rights.

## Requirements

- Emacs 30 or newer (the installers provide 31.1)
- git, used by magit and by straight.el to fetch packages
- GitHub access on first start

## Installation

Back up and remove any existing `~/.emacs`, `~/.emacs.el`, `~/.emacs.d` or `~/.config/emacs` first. Emacs loads those instead of this config.

### NixOS / nix-darwin / home-manager

Add the input:

```nix
emacs = {
  url = "github:andrewzn69/emacs";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Import the module in your home-manager config (pass the input through `extraSpecialArgs`). It installs Emacs, git and JetBrains Mono.

```nix
imports = [ inputs.emacs.homeManagerModules.default ];

services.emacs.enable = true; # optional daemon
```

Rebuild, then clone the config:

```sh
git clone https://github.com/andrewzn69/emacs ~/.config/emacs
```

### Try it with Nix, nothing installed

```sh
nix run github:andrewzn69/emacs
nix run github:andrewzn69/emacs -- -nw
```

This uses the config pinned inside the flake. `~/.config/emacs` is not touched.

### Linux without Nix or root

```sh
curl -fsSLO https://raw.githubusercontent.com/andrewzn69/emacs/main/install/install.sh
less install.sh
sh install.sh
```

The script:
- installs nix-portable, and through it Emacs and git
- adds the `emacs` command to `~/.local/bin`
- puts JetBrains Mono in `~/.local/share/fonts`
- clones the config into `~/.config/emacs`

`~/.local/bin` must be on your `PATH`.

### macOS without Nix

git must be installed (Xcode Command Line Tools).

```sh
curl -fsSLO https://raw.githubusercontent.com/andrewzn69/emacs/main/install/install.sh
less install.sh
sh install.sh
```

The script:
- installs `Emacs.app` into `~/Applications`
- adds the `emacs` command to `~/.local/bin`
- puts JetBrains Mono in `~/Library/Fonts`
- clones the config into `~/.config/emacs`

### Windows

Use a regular (non-admin) PowerShell:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-WebRequest https://raw.githubusercontent.com/andrewzn69/emacs/main/install/install.ps1 -OutFile install.ps1
notepad install.ps1
Unblock-File .\install.ps1
.\install.ps1
```

The script:
- installs Scoop, then git and Emacs through Scoop
- installs JetBrains Mono for your user
- clones the config into `%APPDATA%\.config\emacs`

Emacs uses `%APPDATA%` as its home folder unless a `HOME` environment variable is set. If you set one, the config belongs in `%HOME%\.config\emacs`.

### First start

straight.el installs itself, then clones and builds every package at the exact commit in `lock/default.el`. This takes a while once. Later starts are normal.

## Usage

```sh
emacs              # GUI
emacs -nw          # terminal, e.g. over ssh
emacs --daemon     # background server
emacsclient -c     # open a window on the server
```

## Packages

Every package is declared with `use-package` in a module and installed by straight.el. `lock/default.el` pins every package to a commit, so every machine runs identical versions.

### Add a package

1. Add a `use-package` block to the module it belongs to, or to a new file in `modules/`:
   ```elisp
   (use-package vertico
     :config
     (vertico-mode 1))
   ```
2. If it's a new module, add it to the module list in `init.el`.
3. Restart Emacs. straight.el clones and builds the package.
4. Pin it with `M-x straight-freeze-versions`.
5. Commit the module and `lock/default.el`.

### Update packages

1. Update everything with `M-x straight-pull-all`, or one package with `M-x straight-pull-package`.
2. Restart and test.
3. Pin the new versions with `M-x straight-freeze-versions`.
4. Commit `lock/default.el`.

On your other machines, run `git pull` in the config folder, then `M-x straight-thaw-versions`, then restart.

### Remove a package

1. Delete its `use-package` block.
2. Restart Emacs.
3. Delete its clone with `M-x straight-remove-unused-repos`.
4. Update the lockfile with `M-x straight-freeze-versions`.
5. Commit.

### Change a package

- **Settings or keybindings:** edit the package's `use-package` block.
- **The package's own source:** edit its clone in `<state>/straight/repos/<package>`, then run `M-x straight-rebuild-package`. To keep the change, fork the package and point the recipe at your fork:
  ```elisp
  (use-package evil
    :straight (evil :type git :host github :repo "andrewzn69/evil"))
  ```
  `straight-freeze-versions` checks that your local changes are pushed before pinning.

## Per-machine settings

Copy `local.example.el` to `local.el`. It is git-ignored and loads last. Use it for font size, your org notes folder, or turning a module off on one machine.

## Where things live

The config folder stays a clean git checkout. Everything Emacs writes at runtime (package clones, builds, history, caches) goes to a separate state folder:

- Linux: `~/.local/state/emacs`
- macOS: `~/Library/Application Support/emacs`
- Windows: `%LOCALAPPDATA%\emacs`

## File structure

```
.
├── early-init.el          runs before the first window: moves state out of the repo,
│                          turns off package.el, hides tool/menu/scroll bars
├── init.el                loads core/, then the enabled modules, then local.el
├── core/
│   ├── platform.el        OS and GUI/terminal checks, the only place the OS is detected
│   ├── paths.el           state folder per OS
│   └── packages.el        bootstraps straight.el, points it at lock/, hooks it into use-package
├── modules/               one feature per file, independent of each other
│   ├── ui.el              gruvbox, JetBrains Mono, dashboard
│   ├── evil.el            evil, evil-collection
│   ├── org.el             org
│   └── git.el             magit
├── lock/
│   └── default.el         exact commit of every package
├── local.example.el       template for per-machine local.el
├── install/
│   ├── install.sh         Linux and macOS installer
│   └── install.ps1        Windows installer
├── nix/
│   └── hm-module.nix      home-manager module
├── flake.nix              Nix package, nix run, home-manager module export
├── flake.lock
├── .gitignore             ignores local.el
└── .github/workflows/
    └── ci.yml             starts the config on Linux, macOS and Windows on every push
```

## Design rules

- Modules never depend on each other; shared helpers live in `core/`.
- Only `core/platform.el` checks the OS.
- GUI-only settings (font, images) apply only to graphical windows, so the same config works in a terminal and in the daemon.
- External programs are checked with `executable-find` before use.
- Nothing is installed system-wide.

## Uninstall

**Nix:** remove the input and the import, then rebuild.
```sh
rm -rf ~/.config/emacs ~/.local/state/emacs
```

**Linux without Nix:** also remove `~/.nix-portable` if nothing else uses it.
```sh
rm -rf ~/.config/emacs ~/.local/state/emacs ~/.local/bin/emacs ~/.local/bin/nix-portable ~/.nix-portable
rm -f ~/.local/share/fonts/JetBrainsMono*
```

**macOS:**
```sh
rm -rf ~/Applications/Emacs.app ~/.config/emacs "$HOME/Library/Application Support/emacs" ~/.local/bin/emacs
rm -f ~/Library/Fonts/JetBrainsMono*
```

**Windows:** remove JetBrains Mono in Settings → Fonts. Skip uninstalling git or Scoop if other things use them.
```powershell
scoop uninstall emacs git
Remove-Item -Recurse -Force "$env:APPDATA\.config\emacs", "$env:LOCALAPPDATA\emacs"
scoop uninstall scoop
```

## Known limitations

- Magit is slow on native Windows, taking seconds per status refresh.
- In a terminal (`emacs -nw`) the terminal's font is used, dashboard images don't show, and gruvbox needs a true-colour terminal to look right.
- GUI Emacs through nix-portable on Linux without Nix is untested.
- Company device management may block downloaded apps or PowerShell scripts.
