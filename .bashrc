#
# ~/.bashrc
#

export LANG=en_US.UTF-8
export LC_MESSAGES="C"

PATH=$HOME/bin:$PATH

TERM=xterm-256color

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls -a'
alias l='ls -l'
alias rm='rm -v'
alias cp='cp -v'
alias grep='grep --color'
alias acpi='acpi -V'
alias p2='python2.7'
alias vstartx='startx & vlock'
#Django shortcut
alias pyman='python2.7 ./manage.py'


export PS1='\[\e[0;34m\]\A\[\e[m\]\[\e[1;32m\]::\[\e[m\]\[\e[0;34m\][\u@\h]\[\e[m\]\[\e[1;32m\]::\[\e[m\]\[\e[0;34m\]\w\[\e[m\]\[\e[0;32m\]\$\[\e[m\] '
