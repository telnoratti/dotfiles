#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

eval $(gpg-agent --daemon)

syndaemon -t -k -i 2 -d &
export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
type uim-xim > /dev/null && uim-xim &
export XMODIFIERS=@im='uim'

xmodmap ~/.Xmodmap &&
exec i3
