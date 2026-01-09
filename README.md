# SENAITE dev workspace

This repo is a local dev workspace that wires `senaite.core` and `senaite.lims`
into a buildout-based Plone 5.2.15 instance.

## Prerequisites (macOS)

- Xcode Command Line Tools: `xcode-select --install`
- Homebrew: `brew install cairo pango libffi libxml2 libxslt pkg-config zlib pyenv pyenv-virtualenv`

## First-time setup

```
make init
```

This creates the Python 2.7.18 virtualenv, installs buildout requirements,
and runs buildout.

## Run the server

```
make run
```

Open `http://localhost:8080` and enable "SENAITE LIMS" in Site Setup -> Add-ons.

## Add local add-ons to buildout

1) Add the add-on path to `buildout.cfg` under `develop =`
2) Add the add-on egg name to `buildout.cfg` under `eggs =`
3) Re-run buildout

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
