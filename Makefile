.PHONY: all always-build

RELPATH=$(shell realpath .)

all: version.txt
always-build:

version.txt: version.txt.tmpl always-build
	gomplate < version.txt.tmpl > version.txt
	git add version.txt

prepare-release: version.txt

install:
	git config --global alias.release "!$(RELPATH)/git-release"
	git config --global alias.release-minor "!$(RELPATH)/git-release -y"
	git config --global alias.release-major "!$(RELPATH)/git-release -x"
	git config --global alias.release-hotfix "!$(RELPATH)/git-release -z"
	git config --global alias.template "!$(RELPATH)/git-template"
	git config --global init.defaultBranch "main"
