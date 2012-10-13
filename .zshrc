autoload -U colors && colors
TERM=xterm-256color
PATH=$PATH:$HOME/bin
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' format ''
zstyle ':completion:*' glob 1
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' ignore-parents pwd directory
zstyle ':completion:*' matcher-list '+' '+' '+m:{a-z}={A-Z}' '+m:{a-zA-Z}={A-Za-z} r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=10
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' prompt 'Sp? (%e errors):  '
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' substitute 1
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose false

zstyle :compinstall filename '/home/calvin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install

compdef mosh=ssh

if [ "$SSH_CONNECTION" ]; then
    CONNECTION=">>"
else
    CONNECTION=""
fi

PROMPT="%{$fg[red]%}$CONNECTION%{$fg[blue]%}%n%{$fg[green]%}@%{$fg[blue]%}%m%{$fg[green]%}::%{$fg[blue]%}%3/%{$fg[green]%}$%{$reset_color%} "
RPROMPT="%{$fg[blue]%}%D{%M}%{$fg[green]%}.%{$fg[blue]%}%D{%H}%{$fg[green]%}-%{$fg[blue]%}%D{%d}%{$reset_color%}"

alias ls='ls --color=auto'
alias la='ls -a'
alias l='ls -l'
alias rm='rm -v'
alias cp='cp -v'
alias grep='grep --color'
alias acpi='acpi -V'
alias vstartx='startx & vlock'
alias le='less'
alias kill-all-orphans='sudo pacman -Rs $(pacman -Qtdq)'

bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
