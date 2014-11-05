# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If running interactively, then:
if [ "$PS1" ]; then

    # don't put duplicate lines in the history. See bash(1) for more options
    export HISTCONTROL=ignoreboth
    export HISTSIZE=15000

    export PAGER=less

    # enable color support of ls and also add handy aliases
    eval `dircolors -b`
    alias ls='ls --color=auto'
    alias ll='ls -l'
    alias la='ls -A'
    alias l='ls -CF'

    # set a fancy prompt
    PS1='\[\033[01;34m\]\u\[\033[00m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;31m\]\w\[\033[00m\]\$ '
    # If this is an xterm set the title to user@host:dir
    case $TERM in
    xterm*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
        ;;
    *)
        ;;
    esac

    # set PATH so it includes user's private bin if it exists
    if [ -d ~/bin ] ; then
        export PATH=~/bin:"${PATH}"
    fi
    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc).
    if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi

    if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
    fi
fi

for file in ~/.bashrc.d/*; do
    if [ -x "$file" ]; then
        . $file
    fi
done
