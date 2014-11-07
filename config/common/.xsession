#!/bin/bash

. $HOME/.bashrc

export LANG=de_DE.UTF-8

emacs --daemon &

fvwm

emacsclient -e '(kill-emacs)'
