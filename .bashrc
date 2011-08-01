################################################################################
# Options
################################################################################

shopt -s autocd
shopt -s cmdhist # better history handling of multi-line commands
shopt -s histappend # append history file instead of rewriting
shopt -s extglob # better shell expansion capability
shopt -s cdspell # correct mispelled directory names when using cd
shopt -u mailwarn
ulimit -c unlimited

unset MAILCHECK

PROMPT_COMMAND='history -a' # always append history between sessions
HISTCONTROL='ignoreboth'

# vi style on command line editor
set -o vi
# control L to clear screen
bind -m vi-insert "\C-l":clear-screen
# vi-style completion
bind -m vi-insert "\C-p":dynamic-complete-history
bind -m vi-insert "\C-n":menu-complete
#bind -m vi-insert "\e\C-y":yank-nth-arg

# Setting CFLAGS and CXXFLAGS if none of them are already defined
if [[ -z $CFLAGS ]]; then
    export CFLAGS="-march=amdfam10 -O2 -pipe"
fi

if [[ -z $CXXFLAGS ]]; then
    export CXXFLAGS="$CFLAGS"
fi

# Colorful PS1 variable taken from gentoo's bashrc
if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
    PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

export EDITOR=$(which vim)
export BROWSER=chromium
export TERM=xterm-256color
export PAGER='less -iR'
export MANPAGER='less -iR'
eval $(dircolors -b) # LS_COLORS

################################################################################
# Alias
################################################################################
alias ls="ls --color=auto"
alias pacman_tips='echo "pacman -Syu       # Synchronize with repositories before upgrading packages that are out of date on the local system.
pacman -S         # Install specific package(s) from the repositories
pacman -Up        # Install specific package not from the repositories as a file
pacman -R         # Remove the specified package(s), retaining its configuration(s) and required dependencies
pacman -Rns       # Remove the specified package(s), its configuration(s) and unneeded dependencies
pacman -Si        # Display information about a given package in the repositories
pacman -Ss        # Search for package(s) in the repositories
pacman -Scc       # Clean cache
pacman -Qi        # Display information about a given package in the local database
pacman -Qmq       # Display foreign (aur, abs) packages
pacman -Qs        # Search for package(s) in the local database"'
alias disk-record='echo "growisofs -Z /dev/dvd -allow-limited-size -speed=4 -R -J <arquivos>";echo "cdrecord -v -dev=/dev/scd0 speed=16 <iso>"'
alias oka='echo valeu'
alias bandeco='links -dump http://www.prefeitura.unicamp.br/servicos.php?servID=119 | head -n 23 | tail -n 14 | sed "s/.\{0,35\}[ ]*//" | grep -v ^$ | sed -e "s/\//./g"'
alias mk_vimcfg="cd ~; tar cJvf vim_config-$(date +%F | sed 's/-//g').tar.xz .vim --exclude=.vim/undodir --exclude=.vim/view; cd -"
alias mk_weecfg="cd ~; tar cJvf weechat_config-$(date +%F | sed 's/-//g').tar.xz .weechat --exclude=.weechat/logs; cd -"
alias mk_muttcfg="cd ~; tar cJvf mutt_config-$(date +%F | sed 's/-//g').tar.xz .mutt --exclude=.mutt/cache; cd -"
alias beye='TERM=xterm biew'
alias less='less -iR'
alias callgrind='valgrind --tool=callgrind'
alias tmux='tmux -2'
alias compc='gcc -Wall -Wextra -pedantic -std=c99 -lm -ggdb3'

################################################################################
# Misc
################################################################################

# automatically entering tmux
if [[ -z $(tty | grep /dev/tty) ]]; then # check if is not running on a terminal
    if tmux has-session -t system > /dev/null 2>&1; then
        if [[ -z $TMUX ]]; then
            tmux -2 attach -t system
        else
            # exporting correct terminal, fixes some mutt glitches
            export TERM=screen-256color
        fi
    else
        # create new session (and detach)
        tmux -2 new-session -d -s system
        # create windows
        tmux -2 new-window -t system:1 -n 'weechat' 'weechat-curses' # starting weechat
        # attach
        tmux -2 attach -t system
    fi
fi
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
