PYVENV = $(shell which pyvenv-3.6 pyvenv-3.5 pyvenv-3.4 pyvenv | head -n1)
OUTJS = public/webui/bundle.js

ifeq ($(PYVENV),)
$(error Cannot run pyvenv -- make sure that python>=3.4 is installed)
endif

.PHONY: default help clean clean-all live

default: help

# -- END-USER RELEVANT -- #

venv: ./venv/bin/activate  ## Sets up a virtualenv at ./venv

build: $(OUTJS) ./venv/bin/activate  ## Installs dependencies + compiles the web UI.
	. ./venv/bin/activate; pip install -r requirements.txt

run: $(OUTJS) ./venv/bin/activate server.py  ## Runs the server.
	. ./venv/bin/activate; pip install -r requirements.txt
	. ./venv/bin/activate; ./server.py

# -- THINFS THAT DO STUFF -- #

$(OUTJS):
	(cd webui; make build)

./venv/bin/activate:
	$(PYVENV) ./venv
	sed -i 's/\$$(/(/g' venv/bin/activate.fish
	. ./venv/bin/activate; pip install --upgrade pip

# -- HELPERS -- #

help:  # stolen from marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "%-10s %s\n", $$1, $$2}'

clean:  ## Cleans generated files
	(cd webui; make clean)

clean-all:  ## Cleans everything, removes the venv and all downloaded dependencies
	(cd webui; make clean-all)
	rm -rf ./venv
