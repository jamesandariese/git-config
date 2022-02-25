.PHONY: all always-build

RELPATH := $(shell realpath .)

all: version.txt
always-build:

version.txt: version.txt.tmpl always-build
	gomplate < version.txt.tmpl > version.txt
	git add version.txt

prepare-release: version.txt

install-release:
	git config --global alias.release "!$(RELPATH)/git-release"
	git config --global alias.release-minor "!$(RELPATH)/git-release -y"
	git config --global alias.release-major "!$(RELPATH)/git-release -x"
	git config --global alias.release-hotfix "!$(RELPATH)/git-release -z"

install-template:
	git config --global alias.template "!$(RELPATH)/git-template"

install-alias:
	git config --global alias.alias "!$(RELPATH)/git-alias"

setup-configs:
	git config --global init.defaultBranch "main"
	git config --global push.default "current"
	git config --global push.followTags "true"
	git config --global commit.gpgSign "true"
	git config --global tag.gpgSign "true"

install: install-release install-template setup-configs install-alias

test: always-build
	echo $(eval $@_TAG := $(shell docker build -q -f test/Dockerfile . ) )
	docker run -ti $($@_TAG)
