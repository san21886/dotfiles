#!/usr/bin/env bash

# don't attach to a already started tmux session if running on a console or
# when used with emacs' M-x shell
if [[ -z $(tty | grep /dev/tty) && $EMACS != 't' ]]; then
    if tmux has-session -t system > /dev/null 2>&1; then
        if [[ -z $TMUX ]]; then
            cont=$(tmux ls | grep system | wc -l)
            tmux new-session -d -t system -s "system_$cont"
            tmux selectw -t 0
            tmux attach -t "system_$cont"
        else
            # exporting correct terminal, fixes some mutt glitches
            export TERM=screen-256color
        fi
    else
        # create new session (and detach)
        tmux new-session -d -s system
        # create windows
        tmux new-window -n 'mutt' -t system:1 'mutt; zsh -i'
        tmux new-window -n 'newsbeuter' -t system:2 'newsbeuter; zsh -i'
        #tmux new-window -n 'weechat' -t system:3 'weechat-curses; zsh -i'
        tmux new-window -t system:3
        tmux new-window -t system:4
        tmux new-window -t system:5
        tmux new-window -t system:6
        tmux new-window -t system:7
        tmux new-window -t system:8
        tmux new-window -t system:9
        tmux new-window -t system:10
        tmux selectw -t 0
        # attach
        tmux attach -t system
    fi
fi
