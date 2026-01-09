# SENAITE dev workspace

This repo is a local dev workspace that wires `senaite.core` and `senaite.lims`
into a buildout-based Plone 5.2.15 instance.

## Prerequisites (macOS)

- Xcode Command Line Tools: `xcode-select --install`
- Homebrew: `brew install cairo pango libffi libxml2 libxslt pkg-config zlib pyenv pyenv-virtualenv`

## Clone the repository

This repository uses git submodules. Clone with the `--recursive` flag:

```bash
git clone --recursive <repository-url>
```

## First-time setup

```
make init
```

This command:
1. Clones all git submodules in parallel (using `make clone`)
2. Checks out each submodule to the correct branch/commit
3. Creates the Python 2.7.18 virtualenv
4. Installs buildout requirements
5. Runs buildout

You can also clone submodules separately:
```bash
make clone
```

This will clone all submodules in parallel using `git clone` directly.

## Run the server

```
make run
```

Open `http://localhost:8080` and enable "SENAITE LIMS" in Site Setup -> Add-ons.

## Add new add-ons as submodules

To add a new addon as a git submodule:

```bash
make clone ADDON_URL=https://github.com/user/addon.git ADDON_PATH=senaite.addon.name
```

This will:
1. Add the addon as a git submodule
2. Clone it to the specified path

**Note:** Without arguments, `make clone` clones all existing submodules in parallel.

Then:
1. Add the add-on path to `buildout.cfg` under `develop =`
2. Add the add-on egg name to `buildout.cfg` under `eggs =`
3. Run `make buildout`

Example for `senaite.samplecustom`:
```
[buildout]
eggs =
  senaite.lims
  senaite.core
  senaite.samplecustom

develop =
  senaite.core
  senaite.lims
  senaite.samplecustom
```

Then run:
```
make buildout
make run
```
