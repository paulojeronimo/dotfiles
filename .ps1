#!/bin/bash
# Author: Paulo Jerônimo (@paulojeronimo, pj@paulojeronimo.info)
#
# File imported by ~/.profile with PS1 variable configured to show Git Branches
# 
# Some references: 
# http://code-worrier.com/blog/git-branch-in-bash-prompt/
# http://stackoverflow.com/questions/4133904/ps1-line-with-git-current-branch-and-colors

# curl https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.gitprompt
f=~/.gitprompt; [ -f "$f" ] && source "$f"; unset f

export TTYNAME=`tty|cut -b 6-`

export PS1='\n\[\e[1;94m\]|-- \[\e[1;32m\]\u\[\e[0;39m\]@\[\e[1;36m\]\h\[\e[0;39m\] ($TTYNAME - \t):\[\e[1;31m\]\w\[\e[0;39m\]\[\e[1;35m\]$(__git_ps1 " (%s)")\[\e[0;39m\] \[\e[1;94m\]--|\[\e[0;39m\]\n\$ '
