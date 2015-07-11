CASK ?= cask

test:
	$(CASK) exec ert-runner

.PHONY: test
