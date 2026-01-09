SENAITE addon dev workflow

Goal
- Create a Plone/SENAITE add-on with src layout, register a GenericSetup profile, and install it via Add-ons.

Naming
- Use the namespace package `senaite.addon.<name>`.
- Keep the package name lowercase and short, e.g. `senaite.addon.test`.
- Use a short profile title; it will show in Site Setup -> Add-ons.

Scaffold
- Create a repo folder at the workspace root, e.g. `senaite.addon.test/`.
- Use src layout: `src/senaite/addon/<name>/`.
- Include `setup.py`, `src/senaite/__init__.py`, `src/senaite/addon/__init__.py`, and package `__init__.py`.
- Register a profile in `configure.zcml` and `profiles/default/metadata.xml`.
- Add `entry_points` for `z3c.autoinclude.plugin` so Plone picks it up.

Buildout integration
- Add the add-on path to `buildout.cfg` -> `develop =`.
- Add the add-on egg to `buildout.cfg` -> `eggs =`.
- Run buildout with the pyenv Python 2.7 virtualenv.

Run/Install
- Start the instance with `bin/instance fg`.
- Log into Plone, go to Site Setup -> Add-ons, and install the add-on.

How to add an existing SENAITE add-on (local folder)
- Clone or create the add-on at the repo root, e.g. `senaite.samplecustom/`.
- Ensure the package name matches the egg (e.g. `senaite.samplecustom`).
- Add it to `buildout.cfg`:
  - `develop =` add the folder name.
  - `eggs =` add the egg name.
- Run `make buildout`.
- Restart the server and install via Site Setup -> Add-ons.

How to add a pip-installed add-on (no local source)
- Add the egg to `buildout.cfg` under `eggs =`.
- Re-run buildout and restart the instance.

Feature development guide

Add a browser view (custom page or JSON)
- Create `browser/` with a view class and a template if needed.
- Register the view in ZCML with a browser:page entry and a permission.
- Put templates in `browser/templates/` and reference in ZCML.
- Use a browserlayer to scope the view to your add-on.

Add a browser layer
- Add an interface in `interfaces.py`, e.g. `IMyAddonLayer`.
- Register it in `profiles/default/browserlayer.xml`.
- Reference the layer in your ZCML browser:page registrations.

Add a control panel setting
- Add a registry schema in `registry.py`.
- Register it in `profiles/default/registry.xml`.
- Add a control panel configlet in `profiles/default/controlpanel.xml`.
- Add a form view in `browser/controlpanel.py` and ZCML.

Add Dexterity content
- Add a schema in `content/` and configure FTI in `profiles/default/types/`.
- Register factory/behaviors in ZCML and `profiles/default/types.xml`.
- Add view/edit templates if needed.

Add catalog indexes or metadata columns
- Add `profiles/default/catalog.xml` entries.
- Re-run the `bin/reindex` script after install or upgrade.

Patch or extend SENAITE behavior
- Use a subscriber in `subscribers.py` and ZCML for events.
- Use `setuphandlers.py` for install-time tasks (create folders, set props).
- Use `overrides.zcml` only for targeted overrides.

Upgrade steps
- Add a `profiles/default/metadata.xml` bump and create an upgrade step in
  `profiles/default/upgradeSteps.xml` + `upgrades.py`.
- Keep changes incremental and idempotent.

Minimal files checklist
- `setup.py`
- `src/senaite/__init__.py`
- `src/senaite/addon/__init__.py`
- `src/senaite/addon/<name>/__init__.py`
- `src/senaite/addon/<name>/configure.zcml`
- `src/senaite/addon/<name>/profiles/default/metadata.xml`
- `src/senaite/addon/<name>/profiles/default/profile.zcml` (if profile needs ZCML)
