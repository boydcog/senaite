PYENV_VERSION := 2.7.18/envs/senaite-dev
BUILDOUT_CFG := /Users/voyd/Documents/repos/senaite/buildout.cfg

.PHONY: buildout run init

buildout:
	PYENV_VERSION=$(PYENV_VERSION) pyenv exec buildout -c $(BUILDOUT_CFG)

run:
	DYLD_LIBRARY_PATH=/opt/homebrew/lib:$$DYLD_LIBRARY_PATH PYENV_VERSION=$(PYENV_VERSION) /Users/voyd/Documents/repos/senaite/bin/instance fg

init:
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
