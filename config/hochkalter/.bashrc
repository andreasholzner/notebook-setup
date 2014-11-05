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

    function c () { cd `cdto.pl $1`; }

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


# This line was appended by KDE
# Make sure our customised gtkrc file is loaded.
export GTK2_RC_FILES=$HOME/.gtkrc-2.0


## Perl local::lib
export PERL_LOCAL_LIB_ROOT="$PERL_LOCAL_LIB_ROOT:/home/andreas/perl5";
export PERL_MB_OPT="--install_base /home/andreas/perl5";
export PERL_MM_OPT="INSTALL_BASE=/home/andreas/perl5";
export PERL5LIB="/home/andreas/perl5/lib/perl5:$PERL5LIB";
export PATH="/home/andreas/perl5/bin:$PATH";

# perl env variable
export PERL5LIB=$HOME/Projekte/Perl/.perllib:$HOME/Projekte/Perl/perllib:$PERL5LIB
