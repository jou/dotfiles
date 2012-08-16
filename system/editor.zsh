if command command -v subl >/dev/null && [ -x $(command command -v subl) ]
then
    export EDITOR="subl-wait"
    export HOMEBREW_EDITOR="subl"
else
    export EDITOR="vim"
fi
