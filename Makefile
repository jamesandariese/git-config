.PHONY: all always-build

RELPATH := $(shell realpath .)

all: version.txt
always-build:

version.txt: version.txt.tmpl always-build
	gomplate < version.txt.tmpl > version.txt
	git add version.txt

prepare-release: version.txt

DEFAULT_INSTALLERS += install-release
install-release:
	flock $(CURDIR) git config --global alias.release "!$(RELPATH)/git-release"
	flock $(CURDIR) git config --global alias.release-minor "!$(RELPATH)/git-release -y"
	flock $(CURDIR) git config --global alias.release-major "!$(RELPATH)/git-release -x"
	flock $(CURDIR) git config --global alias.release-hotfix "!$(RELPATH)/git-release -z"

DEFAULT_INSTALLERS += install-template
install-template:
	flock $(CURDIR) git config --global alias.template "!$(RELPATH)/git-template"

DEFAULT_INSTALLERS += install-alias
install-alias:
	flock $(CURDIR) git config --global alias.alias "!$(RELPATH)/git-alias"

DEFAULT_INSTALLERS += install-date-helpers
install-date-helpers:
	flock $(CURDIR) git config --global alias.cd "!$(RELPATH)/git-changedate"
	flock $(CURDIR) git config --global alias.changedate "!$(RELPATH)/git-changedate"
	flock $(CURDIR) git config --global alias.parsedate "!$(RELPATH)/git-parsedate"
	flock $(CURDIR) git config --global alias.codate "!$(RELPATH)/git-codate"
	flock $(CURDIR) git config --global alias.with-date "!$(RELPATH)/git-with-date"

DEFAULT_INSTALLERS += setup-configs
setup-configs: setup-gpg-configs
	flock $(CURDIR) git config --global init.defaultBranch "main"
	flock $(CURDIR) git config --global push.default "current"
	flock $(CURDIR) git config --global push.followTags "true"
	flock $(CURDIR) git config --global status.submoduleSummary 1
	flock $(CURDIR) git config --global pretty.james '%C(auto)%h %s %C(green)%d%n        %C(black)%ae/%ce (%G? %GS)'
	flock $(CURDIR) git config --global format.pretty james

setup-gpg-configs:
ifeq ($(wildcard ~/.gnupg),)
	@echo "no ~/.gnupg found.  skipping gnupg config."
else
	flock $(CURDIR) git config --global commit.gpgSign "true"
	flock $(CURDIR) git config --global tag.gpgSign "true"
endif

install: $(DEFAULT_INSTALLERS)

test: always-build
	echo $(eval $@_TAG := $(shell docker build -q -f test/Dockerfile . ) )
	docker run -ti $($@_TAG)
