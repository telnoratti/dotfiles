#!/bin/zsh
FILES=("${(f)$(ls -a | grep '^\.')}")
FILES=("${(@)FILES:#.copy.s.swp}")
FILES=("${(@)FILES:#.git}")

for file in ${FILES[3,-1]}; do 
    cp -r $file $HOME
done
