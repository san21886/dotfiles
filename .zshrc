################################################################################
# ZSH options and features
################################################################################
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

setopt always_to_end
setopt auto_cd
setopt auto_list
setopt auto_name_dirs
setopt auto_pushd
setopt bang_hist
setopt cdable_vars
setopt complete_in_word
setopt correct
setopt extended_glob
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history
setopt interactive_comments
setopt list_ambiguous
setopt list_types
setopt list_packed
setopt list_rows_first
setopt nohup
setopt notify
setopt numeric_glob_sort
setopt prompt_subst
setopt pushd_ignore_dups
setopt share_history
unsetopt beep
unsetopt checkjobs
unsetopt glob_complete
unsetopt menu_complete

fpath=($HOME/.zsh/acsim/
       /usr/share/doc/task/scripts/zsh
       $fpath)

# global functions
autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -Uz vcs_info
autoload -Uz zsh-mime-setup && zsh-mime-setup

################################################################################
# variables
################################################################################

if [[ ${EUID} == 0 ]] ; then
    PROMPT='%{$fg[red]%}%n@%m %{$fg[blue]%}[${VIMODE}] %~ %# %{$reset_color%}'
else
    if [[ -z $SSH_CLIENT  ]]; then
        PROMPT='%{$fg[blue]%}%1~%{$reset_color%} %# '
        RPROMPT='[${VIMODE}] ${vcs_info_msg_0_}'
    else
        PROMPT='%{$fg[blue]%}%n@%m [${VIMODE}] %~ %# %{$reset_color%}'
    fi
fi

export EDITOR=$(which vim)
export BROWSER=chromium
if [[ $TERM == "screen-256color" ]]; then
    export TERM="screen-256color"
elif [[ -z $SSH_CLIENT ]]; then
    export TERM=st-256color
else
    export TERM=xterm-256color
fi

export PYTHONSTARTUP="$HOME/.pystartup"
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"
export JAVA_FONTS='/usr/share/fonts/TTF'
export BC_ENV_ARGS=~/.bcrc

if [[ -z "$(tty | grep tty)" && -z $SSH_CLIENT ]]; then
    eval $(dircolors -b)
    eval $(dircolors /home/ivan/.zsh/dircolors.256dark)
    export LESS_TERMCAP_mb=$(printf "\e[1;31m")
    export LESS_TERMCAP_md=$(printf "\e[1;38;5;74m")
    export LESS_TERMCAP_me=$(printf "\e[0m")
    export LESS_TERMCAP_se=$(printf "\e[0m")
    export LESS_TERMCAP_so=$(printf "\e[38;5;246m")
    export LESS_TERMCAP_ue=$(printf "\e[0m")
    export LESS_TERMCAP_us=$(printf "\e[04;38;5;146m")
else
    # use basic colors in true terminals
    eval $(dircolors -b)
fi

################################################################################
# vcs_info configuration
################################################################################

# do not chang the order of vcs below, otherwise it won't detect non-git repos
# in home (there exists a git repo with dotfiles)
zstyle ':vcs_info:*' enable hg svn git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '%s@%b'
zstyle ':vcs_info:git:*' actionformats '%s@%b|%a'
zstyle ':vcs_info:hg:*' formats '%s@%b'
zstyle ':vcs_info:hg:*' actionformats '%s@%b|%a'

################################################################################
# completion's configuration
################################################################################

# function to run rehash before every completion
# useful when something new must completed
function _force_rehash {
    (( CURRENT == 1 )) && rehash
    return 1 # Because we didn't really complete anything
}

if [[ -z $SSH_CLIENT  ]]; then
    zstyle ':completion:*' completer _force_rehash _complete _prefix _match _ignored _correct _files
else
    zstyle ':completion:*' completer  _complete _prefix _match _ignored _correct _files
fi

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   false
zstyle ':completion:*:man:*'      menu yes select=3

# never user old style completion
zstyle ':completion:*' use-compctl false

zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*:correct:*' insert-unambiguous true

if [[ -z $SSH_CLIENT  ]]; then
    zstyle ':completion:*' menu select=30 # minimum number of possible matches to switch to menu completion
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
fi

zstyle ':completion:*' original true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 only
zstyle ':completion:*:functions' ignored-patterns '_*'

# directory completion
zstyle ':completion:*' special-dirs .. # complete parent directory

# better kill completion
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

zstyle :compinstall filename '/home/ivan/.zshrc'

# use /etc/hosts and known_hosts for hostname completion
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  `hostname`
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

################################################################################
# functions
################################################################################

ARG=1 # variable used to emulate readline's alt+control+y

function take_nth_arg {
    zle insert-last-word -- -1 $ARG -
    ARG=$(($ARG+1))
}
zle -N take_nth_arg

# taken and modified from http://zshwiki.org/home/examples/zlewidgets
function zle-line-init zle-keymap-select {
    # vi mode settings
    VIMODE="${${KEYMAP/vicmd/n}/(main|viins)/i}"
    zle reset-prompt
    ARG=1
    # fix for del key in st
    if [[ -z $SSH_CLIENT ]]; then
        echoti smkx
    fi
}
zle -N zle-line-init
zle -N zle-keymap-select

# needed for mode changing (viins and vicmd)
function zle-line-finish {
    # vi mode settings
    VIMODE="${${KEYMAP/vicmd/n}/(main|viins)/i}"
    zle reset-prompt
    # fix for del key in st
    if [[ -z $SSH_CLIENT ]]; then
        echoti rmkx
    fi
}
zle -N zle-line-finish

zle-isearch-update() {
    zle -M "Line $HISTNO"
}
zle -N zle-isearch-update

zle-isearch-exit() {
    zle -M ""
}
zle -N zle-isearch-exit

function precmd {
    vcs_info
}

function zathura {
    command zathura $@ --fork > /dev/null 2>&1
}

function _self_insert_git() {
    if [[ $BUFFER = (git(-| )|gitk |qgit )* ]]; then
        if [[ ! $LBUFFER[-1] = '\' ]]; then
            LBUFFER+='\'
        fi
    fi
    zle self-insert
}

zle -N self-insert-git _self_insert_git
bindkey '~' self-insert-git
bindkey '^' self-insert-git
bindkey -M isearch '~' self-insert
bindkey -M isearch '^' self-insert

function set_private_shell() {
    if [[ "$_private" != "yes" ]]; then
        _private="yes"
        unset HISTFILE
        old_PS1="$PS1"
        PS1="$PS1 (private) "
    fi
}

function unset_private_shell() {
    if [[ "$_private" == "yes" ]]; then
        _private="no"
        HISTFILE=~/.zsh_history
        PS1=${old_PS1}
    fi
}

function backward-delete-path () {
    local WORDCHARS="${WORDCHARS:s#/#}"
    zle backward-delete-word
}
zle -N backward-delete-path

function sprunge() {
    curl -F 'sprunge=<-' http://sprunge.us
}

function set_pwd_as_gopath() {
    export GOPATH=$(pwd)
    export PATH=$PATH:$GOPATH/bin
}

################################################################################
# bindings and zle configuration
################################################################################

# vi mode
bindkey -v

# use backspace over everythin on vi mode
bindkey -M viins '^_' backward-delete-char
bindkey -M viins '^h' backward-delete-char

# emacs style movements on viins
bindkey -M viins "^a"  vi-beginning-of-line
bindkey -M viins "^e"  vi-end-of-line
bindkey -M viins "\ef" forward-word
bindkey -M viins "\eb" backward-word
bindkey -M viins "^f"  forward-char
bindkey -M viins "^b"  backward-char
bindkey -M viins "^y"  yank
bindkey -M viins "\ey" yank-pop
bindkey -M viins "^t"  transpose-chars
bindkey -M vicmd "^t"  transpose-chars
bindkey -M viins "\et" transpose-words
bindkey -M vicmd "\et" transpose-words
bindkey -M viins "^xn" infer-next-history
bindkey -M vicmd "^xn" infer-next-history
bindkey -M viins "^w"  backward-kill-word
bindkey -M viins "\ep" backward-delete-path

bindkey "^p" vi-up-line-or-history
bindkey "^n" vi-down-line-or-history

bindkey '\e[1~' vi-beginning-of-line   # Home
bindkey '\e[4~' vi-end-of-line         # End
bindkey '\e[2~' beep                   # Insert
bindkey '\e[3~' delete-char            # Del
bindkey '\e[5~' vi-backward-blank-word # Page Up
bindkey '\e[6~' vi-forward-blank-word  # Page Down

bindkey '\ed' delete-char

# normal C-R, C-F and C-S or history search
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward
bindkey -M viins '^xs' history-incremental-search-forward
bindkey -M vicmd '^xs' history-incremental-search-forward
bindkey -M viins '^g' history-incremental-pattern-search-backward
bindkey -M vicmd '^g' history-incremental-pattern-search-backward

# go back in menu completion
bindkey -M viins '\e[Z' reverse-menu-complete

# control+u erase entire line on vicmd
bindkey -M viins '^u' kill-whole-line # dd can be used also
bindkey -M viins '^k' kill-line

# alt+. to complete previous args
bindkey -M viins '\e.' insert-last-word
bindkey -M viins '\e,' take_nth_arg

# push current line to a buffer, type a new command, pop the pushed line and
# resume editing it
bindkey -M viins '^j' push-line

# aliases

source $HOME/.shell_aliases

# fix escape sequences when zsh is loaded with emacs' M-x shell
if [[ $EMACS == 't' ]]; then
    unsetopt zle
fi

source ~/.zshenv
