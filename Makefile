PYENV_VERSION := 2.7.18/envs/senaite-dev
BUILDOUT_CFG := /Users/voyd/Documents/repos/senaite/buildout.cfg

.PHONY: help buildout run init clone

help:
	@echo "Usage: make <target>"
	@echo "Targets:"
	@echo "  buildout - Build the instance"
	@echo "  run - Run the instance"
	@echo "  init - Initialize the instance"
	@echo "  clone - Clone the submodules"

buildout:
	PYENV_VERSION=$(PYENV_VERSION) pyenv exec buildout -c $(BUILDOUT_CFG)

run:
	DYLD_LIBRARY_PATH=/opt/homebrew/lib:$$DYLD_LIBRARY_PATH PYENV_VERSION=$(PYENV_VERSION) /Users/voyd/Documents/repos/senaite/bin/instance fg

init:
	@echo "Cloning all submodules in parallel..."
	@$(MAKE) clone
	@echo "Checking out submodules to correct branches/commits..."
	@cd add-ons/senaite/senaite.core && git checkout a7f0a07c3b426935640c357d7598d0e84b8624d2 || true
	@cd add-ons/senaite/senaite.app.listing && git checkout release-04 || true
	@cd add-ons/senaite/senaite.app.spotlight && git checkout 2.x || true
	@cd add-ons/senaite/senaite.app.supermodel && git checkout 2.x || true
	@cd add-ons/senaite/senaite.impress && git checkout 2.x || true
	@cd add-ons/senaite/senaite.jsonapi && git checkout 2.x || true
	@cd add-ons/senaite/senaite.lims && git checkout 2.x || true
	@cd add-ons/bika/bika.ui && git checkout 2.x || true
	@cd add-ons/bika/bika.coa && git checkout 2.x || true
	@cd add-ons/bika/bika.reports && git checkout develop || true
	@cd add-ons/senaite/senaite.timeseries && git checkout release-04 || true
	@echo "Submodules initialized and checked out."
	@if ! command -v pyenv >/dev/null 2>&1; then \
		echo "pyenv not found. Install with: brew install pyenv"; \
		exit 1; \
	fi
	@if command -v brew >/dev/null 2>&1; then \
		brew install cairo pango libffi libxml2 libxslt pkg-config zlib pyenv-virtualenv || true; \
	fi
	@pyenv install -s 2.7.18
	@if ! pyenv commands | rg -q "^virtualenv$$"; then \
		echo "pyenv-virtualenv not available. Install with: brew install pyenv-virtualenv"; \
		exit 1; \
	fi
	@if ! pyenv versions --bare | rg -q "^2\.7\.18/envs/senaite-dev$$"; then \
		pyenv virtualenv 2.7.18 senaite-dev; \
	fi
	@pyenv local $(PYENV_VERSION)
	@if ! PYENV_VERSION=$(PYENV_VERSION) pyenv exec python -m pip --version >/dev/null 2>&1; then \
		curl -sSL https://bootstrap.pypa.io/pip/2.7/get-pip.py -o /tmp/get-pip.py; \
		PYENV_VERSION=$(PYENV_VERSION) pyenv exec python /tmp/get-pip.py; \
		rm -f /tmp/get-pip.py; \
	fi
	@PYENV_VERSION=$(PYENV_VERSION) pyenv exec pip install -r /Users/voyd/Documents/repos/senaite/requirements.txt
	@$(MAKE) buildout

clone:
	@if [ -n "$(ADDON_URL)" ] && [ -n "$(ADDON_PATH)" ]; then \
		if [ -d "$(ADDON_PATH)" ]; then \
			echo "Error: Directory $(ADDON_PATH) already exists."; \
			exit 1; \
		fi; \
		echo "Adding new addon as submodule: $(ADDON_PATH)"; \
		git submodule add $(ADDON_URL) $(ADDON_PATH); \
		echo "Addon $(ADDON_PATH) added successfully."; \
		echo "Don't forget to:"; \
		echo "  1. Add $(ADDON_PATH) to buildout.cfg under 'develop =' and 'eggs ='"; \
		echo "  2. Run 'make buildout'"; \
	else \
		echo "Cloning all submodules in parallel using git clone..."; \
		([ ! -d add-ons/senaite/senaite.core ] && git clone https://github.com/senaite/senaite.core.git add-ons/senaite/senaite.core || echo "Skipping senaite.core (already exists)") & \
		([ ! -d add-ons/senaite/senaite.app.listing ] && git clone https://github.com/bikalims/senaite.app.listing.git add-ons/senaite/senaite.app.listing || echo "Skipping senaite.app.listing (already exists)") & \
		([ ! -d add-ons/senaite/senaite.app.spotlight ] && git clone https://github.com/senaite/senaite.app.spotlight.git add-ons/senaite/senaite.app.spotlight || echo "Skipping senaite.app.spotlight (already exists)") & \
		([ ! -d add-ons/senaite/senaite.app.supermodel ] && git clone https://github.com/senaite/senaite.app.supermodel.git add-ons/senaite/senaite.app.supermodel || echo "Skipping senaite.app.supermodel (already exists)") & \
		([ ! -d add-ons/senaite/senaite.impress ] && git clone https://github.com/senaite/senaite.impress.git add-ons/senaite/senaite.impress || echo "Skipping senaite.impress (already exists)") & \
		([ ! -d add-ons/senaite/senaite.jsonapi ] && git clone https://github.com/senaite/senaite.jsonapi.git add-ons/senaite/senaite.jsonapi || echo "Skipping senaite.jsonapi (already exists)") & \
		([ ! -d add-ons/senaite/senaite.lims ] && git clone https://github.com/senaite/senaite.lims.git add-ons/senaite/senaite.lims || echo "Skipping senaite.lims (already exists)") & \
		([ ! -d add-ons/senaite/senaite.storage ] && git clone https://github.com/senaite/senaite.storage.git add-ons/senaite/senaite.storage || echo "Skipping senaite.storage (already exists)") & \
		([ ! -d add-ons/senaite/senaite.instruments ] && git clone https://github.com/bikalims/senaite.instruments.git add-ons/senaite/senaite.instruments || echo "Skipping senaite.instruments (already exists)") & \
		([ ! -d add-ons/bika/bika.ui ] && git clone https://github.com/bikalims/bika.ui.git add-ons/bika/bika.ui || echo "Skipping bika.ui (already exists)") & \
		([ ! -d add-ons/bika/bika.coa ] && git clone https://github.com/bikalims/bika.coa.git add-ons/bika/bika.coa || echo "Skipping bika.coa (already exists)") & \
		([ ! -d add-ons/bika/bika.extras ] && git clone https://github.com/bikalims/bika.extras.git add-ons/bika/bika.extras || echo "Skipping bika.extras (already exists)") & \
		([ ! -d add-ons/bika/bika.reports ] && git clone https://github.com/bikalims/bika.reports.git add-ons/bika/bika.reports || echo "Skipping bika.reports (already exists)") & \
		([ ! -d add-ons/senaite/senaite.crms ] && git clone https://github.com/bikalims/senaite.crms.git add-ons/senaite/senaite.crms || echo "Skipping senaite.crms (already exists)") & \
		([ ! -d add-ons/senaite/senaite.sampleimporter ] && git clone https://github.com/bikalims/senaite.sampleimporter.git add-ons/senaite/senaite.sampleimporter || echo "Skipping senaite.sampleimporter (already exists)") & \
		([ ! -d add-ons/senaite/senaite.samplepointlocations ] && git clone https://github.com/bikalims/senaite.samplepointlocations.git add-ons/senaite/senaite.samplepointlocations || echo "Skipping senaite.samplepointlocations (already exists)") & \
		([ ! -d add-ons/senaite/senaite.timeseries ] && git clone https://github.com/bikalims/senaite.timeseries.git add-ons/senaite/senaite.timeseries || echo "Skipping senaite.timeseries (already exists)") & \
		([ ! -d add-ons/bika/bika.wine ] && git clone https://github.com/bikalims/bika.wine.git add-ons/bika/bika.wine || echo "Skipping bika.wine (already exists)") & \
		([ ! -d add-ons/senaite/senaite.receivedemail ] && git clone https://github.com/bikalims/senaite.receivedemail.git add-ons/senaite/senaite.receivedemail || echo "Skipping senaite.receivedemail (already exists)") & \
		wait; \
		echo "All submodules cloned successfully."; \
	fi
