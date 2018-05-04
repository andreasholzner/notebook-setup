#!/bin/bash

. $HOME/.bashrc

export LANG=de_DE.UTF-8
xset s noblank
xset s off

fvwm

if [ `ps aux | grep 'emacs --daemon' | grep -v grep | wc -l` != "0" ]
then
    echo "Stopping emacs daemon" >> $HOME/.xsession.log
    emacsclient -e '(kill-emacs)'
fi

systemctl poweroff
