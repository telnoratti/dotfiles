source $HOME/.zshrc.pre

# load the lookup subsystem if it's available on the system
zrcautoload lookupinit && lookupinit

zrcautoload -U colors && colors

# make sure our environment is clean regarding colors
for color in BLUE RED GREEN CYAN YELLOW MAGENTA WHITE ; unset $color

# "persistent history"
# just write important commands you always need to ~/.important_commands
if [[ -r ~/.important_commands ]] ; then
    fc -R ~/.important_commands
fi

# append history list to the history file; this is the default but we make sure
# because it's required for share_history.
setopt append_history
# import new commands from the history file also in other zsh-session
setopt share_history
# save each command's beginning timestamp and the duration to the history file
setopt extended_history
# If a new command line being added to the history list duplicates an older
# one, the older command is removed from the list
setopt histignorealldups
# remove command lines from the history list when the first character on the
# line is a space
setopt histignorespace
# if a command is issued that can't be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt auto_cd
# in order to use #, ~ and ^ for filename generation grep word
# *~(*.gz|*.bz|*.bz2|*.zip|*.Z) -> searches for word not in compressed files
# don't forget to quote '^', '~' and '#'!
setopt extended_glob
# display PID when suspending processes as well
setopt longlistjobs
# try to avoid the 'zsh: no matches found...'
setopt nonomatch
# report the status of backgrounds jobs immediately
setopt notify
# whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all
# not just at the end
setopt completeinword
# Don't send SIGHUP to background processes when the shell exits.
setopt nohup
# Avoid beeps
setopt nobeep
# * shouldn't match dotfiles. ever.
setopt noglobdots
# use zsh style word splitting
setopt noshwordsplit
# don't error out when unset parameters are used
setopt unset

# history
ZSHDIR=${ZDOTDIR:-${HOME}/.zsh}
HISTFILE=${ZDOTDIR:-${HOME}}/.zsh_history
HISTSIZE=5000
SAVEHIST=10000
bindkey -v

# Load a few modules
for mod in parameter complist deltochar mathfunc ; do
    zmodload -i zsh/${mod} 2>/dev/null || print "Notice: no ${mod} available :("
done
# autoload zsh modules when they are referenced
zmodload -a  zsh/stat    zstat
zmodload -a  zsh/zpty    zpty
zmodload -ap zsh/mapfile mapfile

# Don't want this always loaded
alias url-quote='autoload -U url-quote-magic ; zle -N self-insert url-quote-magic'

# completion system
if zrcautoload compinit ; then
    compinit || print 'Notice: no compinit available :('
else
    print 'Notice: no compinit available :('
    function compdef { }
fi

# setting some default values
NOCOR=${NOCOR:-0}
NOMENU=${NOMENU:-0}
NOPRECMD=${NOPRECMD:-0}
COMMAND_NOT_FOUND=${COMMAND_NOT_FOUND:-0}
BATTERY=${BATTERY:-0}
ZSH_NO_DEFAULT_LOCALE=${ZSH_NO_DEFAULT_LOCALE:-0}

typeset -ga ls_options
typeset -ga grep_options
if ls --help 2> /dev/null | grep -q GNU; then
    ls_options=( --color=auto )
elif [[ $OSTYPE == freebsd* ]]; then
    ls_options=( -G )
fi
if grep --help 2> /dev/null | grep -q GNU || \
   [[ $OSTYPE == freebsd* ]]; then
    grep_options=( --color=auto )
fi

## Setting TZ for those programs that need it
TZ=$(xcat /etc/timezone)

# Systemd uses timedatectl
if [[ -z $TZ ]] && check_com timedatectl; then
    TZ=$(timedatectl status | grep Timezone | awk '{print $2}');
fi

if check_com -c vim ; then
#v#
    export EDITOR=${EDITOR:-vim}
else
    export EDITOR=${EDITOR:-vi}
fi

# color setup for ls:
check_com -c dircolors && eval $(dircolors -b)
# color setup for ls on OS X / FreeBSD:
isdarwin && export CLICOLOR=1
isfreebsd && export CLICOLOR=1
unset fdir func

export MAIL=${MAIL:-/var/mail/$USER}
# mailchecks
MAILCHECK=30
# report about cpu-/system-/user-time of command if running longer than
# 5 seconds
REPORTTIME=5
# watch for everyone but me and root
watch=(notme root)

export TERM=xterm-256color
export SHELL="/bin/zsh"
export PATH=$PATH:$HOME/bin
export VIM_OPTIONS="-p"
export COLORTERM="yes"
# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

if [ -f "${HOME}/.gpg-agent-info" ]; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
fi

GPG_TTY=$(tty)
export GPG_TTY

[ -n "$TMUX" ] && export TERM=screen-256color

if [ "$SSH_CONNECTION" ]; then
    CONNECTION=">>"
else
    CONNECTION=""
fi

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# set colors for use in prompts (modern zshs allow for the use of %F{red}foo%f
# in prompts to get a red "foo" embedded, but it's good to keep these for
# backwards compatibility).
if zrcautoload colors && colors 2>/dev/null ; then
    BLUE="%{${fg[blue]}%}"
    RED="%{${fg_bold[red]}%}"
    GREEN="%{${fg[green]}%}"
    CYAN="%{${fg[cyan]}%}"
    MAGENTA="%{${fg[magenta]}%}"
    YELLOW="%{${fg[yellow]}%}"
    WHITE="%{${fg[white]}%}"
    NO_COLOR="%{${reset_color}%}"
else
    BLUE=$'%{\e[1;34m%}'
    RED=$'%{\e[1;31m%}'
    GREEN=$'%{\e[1;32m%}'
    CYAN=$'%{\e[1;36m%}'
    WHITE=$'%{\e[1;37m%}'
    MAGENTA=$'%{\e[1;35m%}'
    YELLOW=$'%{\e[1;33m%}'
    NO_COLOR=$'%{\e[0m%}'
fi

## Load the prompt
xsource $HOME/.zshrc.ps

## Load the ZLE configuration
xsource $HOME/.zshrc.zle

# Terminal-title wizardry
function ESC_print () {
    info_print $'\ek' $'\e\\' "$@"
}
function set_title () {
    info_print  $'\e]0;' $'\a' "$@"
}
function info_print () {
    local esc_begin esc_end
    esc_begin="$1"
    esc_end="$2"
    shift 2
    printf '%s' ${esc_begin}
    printf '%s' "$*"
    printf '%s' "${esc_end}"
}
function grml_reset_screen_title () {
    # adjust title of xterm
    # see http://www.faqs.org/docs/Linux-mini/Xterm-Title.html
    [[ ${NOTITLE:-} -gt 0 ]] && return 0
    case $TERM in
        (xterm*|rxvt*)
            set_title ${(%):-"%n@%m: %~"}
            ;;
    esac
}
function grml_vcs_to_screen_title () {
    if [[ $TERM == screen* ]] ; then
        if [[ -n ${vcs_info_msg_1_} ]] ; then
            ESC_print ${vcs_info_msg_1_}
        else
            ESC_print "zsh"
        fi
    fi
}
function grml_maintain_name () {
    # set hostname if not running on host with name 'grml'
    if [[ -n "$HOSTNAME" ]] && [[ "$HOSTNAME" != $(hostname) ]] ; then
       NAME="@$HOSTNAME"
    fi
}
function grml_cmd_to_screen_title () {
    # get the name of the program currently running and hostname of local
    # machine set screen window title if running in a screen
    if [[ "$TERM" == screen* ]] ; then
        local CMD="${1[(wr)^(*=*|sudo|ssh|-*)]}$NAME"
        ESC_print ${CMD}
    fi
}
function grml_control_xterm_title () {
    case $TERM in
        (xterm*|rxvt*)
            set_title "${(%):-"%n@%m:"}" "$1"
            ;;
    esac
}
zrcautoload add-zsh-hook || add-zsh-hook () { :; }
if [[ $NOPRECMD -eq 0 ]]; then
    add-zsh-hook precmd grml_reset_screen_title
    add-zsh-hook precmd grml_vcs_to_screen_title
    add-zsh-hook preexec grml_maintain_name
    add-zsh-hook preexec grml_cmd_to_screen_title
    if [[ $NOTITLE -eq 0 ]]; then
        add-zsh-hook preexec grml_control_xterm_title
    fi
fi

# 'hash' some often used directories
hash -d deb=/var/cache/apt/archives
hash -d pac=/var/cache/pacman/pkg
hash -d ports=/usr/local/ports
hash -d doc=/usr/share/doc
hash -d linux=/lib/modules/$(command uname -r)/build/
hash -d log=/var/log
hash -d slog=/var/log/syslog
hash -d src=/usr/src


# do we have GNU ls with color-support?
if [[ "$TERM" != dumb ]]; then
    # List files with colors (\kbd{ls -b -CF \ldots})
    alias ls='ls -b -CF '${ls_options:+"${ls_options[*]}"}
    # List all files, with colors (\kbd{ls -la \ldots})
    alias la='ls -la '${ls_options:+"${ls_options[*]}"}
    # List files with long colored list, without dotfiles (\kbd{ls -l \ldots})
    alias ll='ls -l '${ls_options:+"${ls_options[*]}"}
    # List files with long colored list, human readable sizes (\kbd{ls -hAl \ldots})
    alias lh='ls -hAl '${ls_options:+"${ls_options[*]}"}
    # List files with long colored list, append qualifier to filenames (\kbd{ls -lF \ldots})\\&\quad(\kbd{/} for directories, \kbd{@} for symlinks ...)
    alias l='ls -lF '${ls_options:+"${ls_options[*]}"}
else
    alias ls='ls -b -CF'
    alias la='ls -la'
    alias ll='ls -l'
    alias lh='ls -hAl'
    alias l='ls -lF'
fi
## Listing stuff
# Only show dot-directories
alias lad='ls -d .*(/)'
# Only show dot-files
alias lsa='ls -a .*(.)'
# Only files with setgid/setuid/sticky flag
alias lss='ls -l *(s,S,t)'
# Only show symlinks
alias lsl='ls -l *(@)'
# Display only executables
alias lsx='ls -l *(*)'
# Display world-{readable,writable,executable} files
alias lsw='ls -ld *(R,W,X.^ND/)'
# Display the ten biggest files
alias lsbig="ls -flh *(.OL[1,10])"
# Only show directories
alias lsd='ls -d *(/)'
# Only show empty directories
alias lse='ls -d *(/^F)'
# Display the ten newest files
alias lsnew="ls -rtlh *(D.om[1,10])"
# Display the ten oldest files
alias lsold="ls -rtlh *(D.Om[1,10])"
# Display the ten smallest files
alias lssmall="ls -Srl *(.oL[1,10])"

# Be verbose
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'
alias acpi='acpi -V'

# use colors when GNU grep with color-support
# Execute \kbd{grep -{}-color=auto}
(( $#grep_options > 0 )) && alias grep='grep '${grep_options:+"${grep_options[*]}"}

# Handy
alias le='less'
alias slay="killall -9"

# general
# Execute \kbd{du -sch}
alias da='du -sch'
# Execute \kbd{jobs -l}
alias j='jobs -l'


# some useful aliases
# Remove current empty directory. Execute \kbd{cd ..; rmdir \$OLDCWD}
alias rmcdir='cd ..; rmdir $OLDPWD || cd $OLDPWD'
# ssh with StrictHostKeyChecking=no \\&\quad and UserKnownHostsFile unset
alias insecssh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
# scp with StrictHostKeyChecking=no \\&\quad and UserKnownHostsFile unset
alias insecscp='scp -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'

# work around non utf8 capable software in utf environment via $LANG and luit
if check_com isutfenv && check_com luit ; then
    if check_com -c mrxvt ; then
        isutfenv && [[ -n "$LANG" ]] && \
            alias mrxvt="LANG=${LANG/(#b)(*)[.@]*/$match[1].iso885915} luit mrxvt"
    fi

    if check_com -c aterm ; then
        isutfenv && [[ -n "$LANG" ]] && \
            alias aterm="LANG=${LANG/(#b)(*)[.@]*/$match[1].iso885915} luit aterm"
    fi

    if check_com -c centericq ; then
        isutfenv && [[ -n "$LANG" ]] && \
            alias centericq="LANG=${LANG/(#b)(*)[.@]*/$match[1].iso885915} luit centericq"
    fi
fi

xsource ~/.zshrc.tools
