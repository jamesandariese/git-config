.PHONY: all always-build

RELPATH := $(shell realpath .)

all: version.txt
always-build:

version.txt: version.txt.tmpl always-build
	gomplate < version.txt.tmpl > version.txt
	git add version.txt

prepare-release: version.txt

install-release:
	flock $(CURDIR) git config --global alias.release "!$(RELPATH)/git-release"
	flock $(CURDIR) git config --global alias.release-minor "!$(RELPATH)/git-release -y"
	flock $(CURDIR) git config --global alias.release-major "!$(RELPATH)/git-release -x"
	flock $(CURDIR) git config --global alias.release-hotfix "!$(RELPATH)/git-release -z"

install-template:
	flock $(CURDIR) git config --global alias.template "!$(RELPATH)/git-template"

install-alias:
	flock $(CURDIR) git config --global alias.alias "!$(RELPATH)/git-alias"

setup-configs: setup-gpg-configs
	flock $(CURDIR) git config --global init.defaultBranch "main"
	flock $(CURDIR) git config --global push.default "current"
	flock $(CURDIR) git config --global push.followTags "true"

setup-gpg-configs:
ifeq ($(wildcard ~/.gnupg),)
	@echo "no ~/.gnupg found.  skipping gnupg config."
else
	flock $(CURDIR) git config --global commit.gpgSign "true"
	flock $(CURDIR) git config --global tag.gpgSign "true"
endif

install: install-release install-template setup-configs install-alias

test: always-build
	echo $(eval $@_TAG := $(shell docker build -q -f test/Dockerfile . ) )
	docker run -ti $($@_TAG)
