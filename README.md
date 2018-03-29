[![Build Status](https://travis-ci.org/universal-ctags/homebrew-universal-ctags.svg?branch=master)](https://travis-ci.org/universal-ctags/homebrew-universal-ctags)
[![GitHub issues](https://img.shields.io/github/issues/universal-ctags/homebrew-universal-ctags.svg?style=flat-square)](https://github.com/universal-ctags/homebrew-universal-ctags/issues)
[![RTD build status](https://readthedocs.org/projects/ctags/badge)](http://docs.ctags.io)
[![license](https://img.shields.io/github/license/universal-ctags/homebrew-universal-ctags.svg?style=flat-square)](https://raw.githubusercontent.com/universal-ctags/homebrew-universal-ctags/master/COPYING)

# Homebrew Tap for Universal Ctags

Given the lack of activity on the official Exuberant Ctags source,
it has been forked and renamed to Universal Ctags and can be found
at https://github.com/universal-ctags/ctags.

## Usage

```
brew install --HEAD universal-ctags/universal-ctags/universal-ctags
```

## Future

When Universal Ctags has a tagged release, this formula should be moved
to the official Homebrew repository. The formula should then be deleted
from this repo and a `tap_migrations.json` file be added to ensure an
automatic transition for existing users of the formula.
