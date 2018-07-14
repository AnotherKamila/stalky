PIPENV = $(shell which pipenv | head -n1)
OUTJS = webui/public/bundle.js
PREBUILTJS = dist/bundle.js

ifeq ($(PIPENV),)
$(error Cannot find pipenv -- make sure that it is installed.)
endif

.PHONY: default help clean clean-all live dev-hooks

default: help

# -- END-USER RELEVANT -- #

build: $(OUTJS)  ## Install dependencies + compile the web UI
	pipenv install

dontbuild: $(PREBUILTJS)  ## Use the pre-built file instead of compiling yourself. Run before `make run`.
	cp $(PREBUILTJS) $(OUTJS)

run: $(OUTJS)  server.py  ## Runs the server.
	pipenv install
	pipenv run ./server.py

dev-hooks:  ## Set up git hooks useful for development.
	[ -f .git/hooks/pre-commit ] && mv .git/hooks/pre-commit .git/hooks/pre-commit.old
	echo '#!/bin/sh\nexec 1>&2\nset -e\n(cd webui; make build)\ncp $(OUTJS) $(PREBUILTJS)\ngit add $(PREBUILTJS)' > .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit

# -- THINGS THAT DO STUFF -- #

$(OUTJS):
	(cd webui; make build)

# -- HELPERS -- #

help:  # stolen from marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "%-10s %s\n", $$1, $$2}'

clean:  ## Clean generated files
	(cd webui; make clean)
	rm -rf dist/*


clean-all: clean  ## Clean everything, remove the venv and all downloaded dependencies
	(cd webui; make clean-all)
