if command command -v subl >/dev/null && [ -x $(command command -v subl) ]
then
    export EDITOR="subl-wait"
else
    export EDITOR="vim"
fi
