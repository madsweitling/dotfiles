#!/bin/bash

# Upgrade bash history buffer sizes, etc
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTCONTROL=ignoreboth
export HISTIGNORE="ls:bg:fg:history"
export HISTTIMEFORMAT="%F %T "

# Write history on each command, not just on exit from shell
export PROMPT_COMMAND="history -a"

# Append to history instead of overwriting
shopt -s histappend

# Write a better .inputrc if not already done
if [[ ! -f ~/.inputrc ]]; then
    cat << EOF > ~/.inputrc
"\e[A": history-search-backward
"\e[B": history-search-forward
"\e[C": forward-char
"\e[D": backward-char
EOF
    echo "Wrote new ~/.inputrc"
fi

# Use .inputrc
bind -f ~/.inputrc

# Python stuff
if [[ ! -f ~/.pythonstartup ]]; then
    cat << EOF > ~/.pythonstartup
# Log all Django SQL queries made when running in interactive Python shells
import logging
l = logging.getLogger("django.db.backends")
l.setLevel(logging.DEBUG)
l.addHandler(logging.StreamHandler())
EOF
    echo "Wrote new ~/.pythonstartup"
fi

# Use ~/.pythonstartup
export PYTHONSTARTUP=~/.pythonstartup

# Add Bitbucket private key to keyring, so TortoiseHg can use it
export SSH_ASKPASS="/usr/bin/ssh-askpass"
cat /dev/null | ssh-add &
if [[ `ssh-add -l` != *bucket* ]]; then
    ssh-add ~/.ssh/bitbucket_private.key
fi

# Add .bash_customization import to .bashrc
if grep -Fq ".bash_customization.sh" ~/.bashrc ; then
    echo "Already added .bash_customization.sh import to ~/.bashrc, skipping"
else
    cat << EOF >> ~/.bashrc

# Import .bash_customization.sh
if [ -f ~/.bash_customization.sh ]; then
    . ~/.bash_customization.sh
fi
EOF
    . ~/.bashrc
    echo "Added .bash_customization.sh import to ~/.bashrc"
fi
