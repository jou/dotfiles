# Uses git's autocompletion for inner commands. Assumes an install of git's
# bash `git-completion` script at $completion below (this is where Homebrew
# tosses it, at least).
git_completion=/usr/local/etc/bash_completion.d/git-completion.bash

if ! type _git >/dev/null 2>/dev/null && test -f $git_completion
then
  source $git_completion
fi

