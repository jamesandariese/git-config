#!/bin/bash

# we use backticks in our markdown and reference them in our bash so we need to
# disable the shellcheck check for things which will not be evaluated because
# they're in single quotes.
#    shellcheck disable=SC2016

set -e


if [ -n "$(git config user.email)" ] || [ -n "$(git config user.name)" ];then
    echo "detected a configured git."
    echo "must run via 'make test' to avoid wrecking your git config"
    exit 1
fi

make install

cat-example() {
set -x
    # finds the section in the file, prints the following bash code block, and exits
    awk -v section="$2" '$0 == section {s=1} /^```$/ && p {p=0; exit} p {print} /^```bash$/ && s {p=1}' "$1"
}

reset-test() {
    cd /
    rm -rf /test
    mkdir /test
    cd /test
}

reset-test
if (echo set -e ; cat-example '/src/README.md' '#### An example repository using `git-release`') | bash;then
    echo "should require user.name and user.email to be set but didn't fail"
    exit 1
else
    echo "FAILURE ABOVE EXPECTED"
fi
echo;echo;echo;echo;echo

# git will work with just the email set but git template wants the name.  check for this, too.
git config --global user.email x@y.z

git template -v

reset-test
if (echo set -ex ; cat-example '/src/README.md' '#### An example repository using `git-release`') | bash;then
    echo "git template should require user.name to be set"
    exit 1
fi
echo;echo;echo;echo;echo

reset-test
git config --global user.name 'testy mcuserton'
if ! (echo set -ex ; cat-example '/src/README.md' '#### An example repository using `git-release`') | bash;then
    echo "Example in README.md failed to run properly"
    exit 1
fi
echo;echo;echo;echo;echo

### Now we're going to test the versioning/prepare-release functionality
### for this, we'll examine the commits that have been made in the previous
### successful run.
### the version.txt on main should say "latest"
### the version.txt on tagged releases should contain the version.
### the checkout of release/v0.1 expects to have the latest release on that line, 0.1.1

cd /test
git checkout v0.1.0
GIT_TEMPLATE_VERSION="$(cat version.txt)"
if [ "$GIT_TEMPLATE_VERSION" != "0.1.0" ];then
    echo "git template -v didn't return the expected value -- expected 0.1.0, got $GIT_TEMPLATE_VERSION"
    exit 1
fi
git checkout main
GIT_TEMPLATE_VERSION="$(cat version.txt)"
if [ "$GIT_TEMPLATE_VERSION" != "latest" ];then
    echo "git template -v didn't return the expected value -- expected latest, got $GIT_TEMPLATE_VERSION"
    exit 1
fi
git checkout release/v0.1
GIT_TEMPLATE_VERSION="$(cat version.txt)"
if [ "$GIT_TEMPLATE_VERSION" != "0.1.1" ];then
    echo "git template -v didn't return the expected value -- expected 0.1.1, got $GIT_TEMPLATE_VERSION"
    exit 1
fi

echo "TEST SUCCESS"
