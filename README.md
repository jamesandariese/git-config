# `git-config`

Git configs for standardized git workflowing

## Usage

### Prerequisites

* [`gomplate`][1]

### Installation

```bash
make install
```

## Commands

### `git-template`

Template a repo's basic files like README.md and LICENSE from the
`templates.tmpl` folder.

### `git-release`

Release versions of a project using a standardized workflow.

These commands use the abbreviations x for major, y for minor, and z for hotfix.

* release a hotfix: `git release-hotfix PICK_or_RANGE`
  * must be on the release branch on which to release the hotfix
  * will _cherry-pick_, not merge
  * will update the cherry-pick before committing with updated version info
  * will tag a new release with hotfix version
* release a minor version: `git release`
  * must be on main
  * the commit at which you wish to create a new release must be HEAD
  * will create a new branch from HEAD
  * will tag a new release with an incremented minor from the latest discovered
    major.minor (consuls local branches)
  * DOES NOT check if your new release shares common history with the previous
    minor release for this major version
* release a major version: `git release-major`
  * identical to releasing a minor version except:
    * will tag a new release with an incremented major from the latest
      discovered major (consults local branches)

```bash
git init

# support older git and commands without --root
git commit --allow-empty -m 'initial commit'

# use our templater!
git template

git add README.md LICENSE
git commit -m "initial import"

# release v0.0.1
# contains the readme and license
git release

date > test.txt
git add test.txt
git commit -m 'add a test file'

# release v0.1.0
# contains readme, license, and test file
git release

# let's use a feature branch
git checkout -b feature/add-cats

echo '
    |\__/,|   (`\
  _.|o o  |_   ) )
-(((---(((--------' > cat1.txt
git add cat1.txt
git commit -m 'add cat #1'

echo '
 /\_/\
( o.o )
 > ^ <' > cat2.txt
git add cat2.txt
git commit -m 'add cat #2'

# we can use merge commits
git checkout main
git merge --no-ff feature/add-cats

# EMERGENCY CATS NEEDED -- let's make 0.1.1 with both cats this will create a
# squashed commit of the entire range with an automatic commit message containing
# all the commit abbrev hashes and subject lines:
# 
#    Hotfix v0.1.1
#    
#    af7cab9 add cat #2
#    fc65add add cat #1

git checkout release/v0.1
git release-hotfix feature/add-cats~2..feature/add-cats

git checkout main
# release v1.0.0
git release-major  # or git release -x
```

### References

[gomplate]: https://docs.gomplate.ca/installing/
