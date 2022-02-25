.PHONY: all always-build

RELPATH=$(shell realpath .)

all:
always-build:

install:
	git config --global alias.release "!$(RELPATH)/git-release"
	git config --global alias.release-minor "!$(RELPATH)/git-release -y"
	git config --global alias.release-major "!$(RELPATH)/git-release -x"
	git config --global alias.release-hotfix "!$(RELPATH)/git-release -z"
	git config --global alias.template "!$(RELPATH)/git-template"
	git config --global init.defaultBranch "main"
