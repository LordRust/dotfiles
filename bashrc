# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# remove XON/XOFF
   stty -ixon


###########
# History #
###########
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# Sync history between sessions
export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

####################
## Tab completions #
####################
export PKG_CONFIG_PATH=/usr/share/pkgconfig:$PKG_CONFIG_PATH
# tab loops through alternatives
# Windows style
#[[ $- = *i* ]] && bind TAB:menu-complete
#bind '"\e[Z": complete' #shift-tab to normal bash

bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"

#
set completion-prefix-display-length 2

# Ignore case when tabbing
set completion-ignore-case on

# show all ambiguous directly
set show-all-if-ambiguous on
set show-all-if-unmodified on

# Treat hyphen and underscore as the same
set completion-map-case on

#########
# Other #
#########
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi
#
# If the current shell is already multiplexed, I will not create a new
# tmux session. If the current shell session is a remote one, and at
# least one tmux session is already running on that machine, I will
# simply attach to the most recent one. Otherwise, yes, I will start a
# new tmux session for every new shell session.
#[ ! "$TMUX" ] &&
#    ([ "$SSH_CONNECTION" ] && tmux -2 attach || tmux -2 new) &&
#    [ ! -e /tmp/dontquit ] && exit 0


####################
# OS specific part #
####################
_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true
_isosx=false
[[ "$(uname -s)" =~ Darwin ]] && _isosx=true
_isbioinf=false
[[ "$(hostname -s)" =~ fbtserver|s-calc-fat01-p|s-sdi-calc[1..2]-p ]] && _isbioinf=true
[[ "$(whoami)" =~ jlr ]] && _isbioinf=true
_iscoco=false
[[ "$(hostname -s)" =~ coco ]] && _iscoco=true
_isRS=false
[[ "$(hostname -s)" =~ RS30106828 ]] && _isRS=true


# Linux
if $_islinux; then
	# set a fancy prompt (non-color, unless we know we "want" color)
	case "$TERM" in
		xterm-color) color_prompt=yes;;
	esac

	unset GIT_ASKPASS
	unset SSH_ASKPASS

	# uncomment for a colored prompt, if the terminal has the capability; turned
	# off by default to not distract the user: the focus in a terminal window
	# should be on the output of commands, not on the prompt
	force_color_prompt=yes

	if [ -n "$force_color_prompt" ]; then
		if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
			# We have color support; assume it's compliant with Ecma-48
			# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
			# a case would tend to support setf rather than setaf.)
			color_prompt=yes
		else
			color_prompt=
		fi
	fi

	# Different colors for different hosts
	_isbioinf=false
    [[ "$(hostname -s)" =~ srv-1-ux-calc01|s-calc-fat01-p|MTLUCMDS2 ]] && _isbioinf=true
    STARTFGCOLOR='\[\e[01;33m\]'
	if $_isbioinf; then
		STARTFGCOLOR='\[\e[01;32m\]'
	fi
	if [ "$color_prompt" = yes ]; then
		PS1="${debian_chroot:+($debian_chroot)}$STARTFGCOLOR\u@\h\[\033[00m\]: \[\033[01;34m\]\w\[\033[00m\]\$ "
	else
		PS1='${debian_chroot:+($debian_chroot)}\u@\h: \w\$ '
	fi
	unset color_prompt force_color_prompt

	# If this is an xterm set the title to user@host:dir
	case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
	esac
	# Set highligt in less
	# enter_standout_mode reverse
	export LESS_TERMCAP_so=$'\E[7m'
	#  exit_standout_mode normal
	export LESS_TERMCAP_se=$'\E[27m'
fi

#Bioinf
#if $_isbioinf; then
    export EDITOR='emacs -nw'
    export VISUAL=$EDITOR
    export ME='jlr'
#fi

# Mac OS X
if $_isosx; then
	STARTFGCOLOR='\[\e[0;33m\]'
	#STARTBGCOLOR="\e[47m"
	ENDCOLOR="\[\e[0m\]"

	#\e[{code}m for background
	#\e[0;{code}m for regular 1; bold 4; underline

	#Black 0;30
	#Red 0;31
	#Green 0;32
	#Brown 0;33
	#Blue 0;34
	#Purple 0;35
	#Cyan 0;36
	#White 0;37

	export PS1="$STARTFGCOLOR$STARTBGCOLOR\u$ENDCOLOR@\h \w\$ "

	export EDITOR='/opt/homebrew-cask/Caskroom/emacs-mac/emacs-24.5-z-mac-5.7/Emacs.app/Contents/MacOS/Emacs.sh -nw'
	export VISUAL=$EDITOR

	export BYOBU_PREFIX=$(brew --prefix)
#	[ -r /Users/jonas/.byobu/prompt ] && . /Users/jonas/.byobu/prompt   #byobu-prompt# 
fi

if $_iscoco; then
	export DISPLAY=:0
	# source /home/jb/miniconda3/etc/profile.d/conda.sh
	# >>> conda initialize >>>
	# !! Contents within this block are managed by 'conda init' !!
	__conda_setup="$('/home/jb/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
	if [ $? -eq 0 ]; then
		eval "$__conda_setup"
	else
		if [ -f "/home/jb/miniconda3/etc/profile.d/conda.sh" ]; then
 . "/home/jb/miniconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
	else
 export PATH="/home/jb/miniconda3/bin:$PATH"  # commented out by conda initialize
		fi
	fi
	unset __conda_setup
	# <<< conda initialize <<<
fi

if $_isRS; then
	export DISPLAY=localhost:0.0
	# >>> conda initialize >>>
	# !! Contents within this block are managed by 'conda init' !!
	__conda_setup="$('/data/bnf/sw/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
	if [ $? -eq 0 ]; then
		eval "$__conda_setup"
	else
		if [ -f "/data/bnf/sw/miniconda3/etc/profile.d/conda.sh" ]; then
 . "/data/bnf/sw/miniconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
		else
 export PATH="/data/bnf/sw/miniconda3/bin:$PATH"  # commented out by conda initialize
		fi
	fi
	unset __conda_setup
	# <<< conda initialize <<<
fi


