# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

unset rc

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# remove XON/XOFF
   stty -ixon


###########
# History #
###########
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# ignore certain things
HISTIGNORE='fz:history'

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
fi


####################
# OS specific part #
####################
_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true
_isosx=false
[[ "$(uname -s)" =~ Darwin ]] && _isosx=true
_iscoco=false
[[ "$(hostname -s)" =~ coco ]] && _iscoco=true
_ist14s=false
[[ "$(hostname -s)" =~ t14s ]] && _ist14s=true
_isEklient=false
[[ "$(hostname -s)" =~ RS30134650|RS30106828|RS30134699 ]] && _isEklient=true
_isRS=false
[[ "$(hostname -s)" =~ MTLUCMDS1|MTLUCMDS2 ]] && _isRS=true
_ishopper=false
[[ "$(hostname -s)" =~ rs-fs[1-2]|rs-fe1|rs-n[1-3] ]] && _ishopper=true
_isnixos=false
[[ "$(hostname -s)" =~ nixos ]] && _isnixos=true

# Linux
if $_islinux; then
	# set a fancy prompt (non-color, unless we know we "want" color)
	case "$TERM" in
		xterm-color) color_prompt=yes;;
	esac

	GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=:ln=32:bn=32:se=36'

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
	if [[ "$(hostname -s)" =~ MTLUCMDS2 ]] ; then
		HOSTNAMECOLOR='\[\e[01;32m\]'
	elif [[ "$(hostname -s)" =~ MTLUCMDS1 ]] ; then
		HOSTNAMECOLOR='\[\e[01;33m\]'
	elif [[ $_iscoco = 'true' ]] || [[ $_ist14s = 'true' ]] ; then
		HOSTNAMECOLOR='\[\e[01;32m\]'
	elif $_ishopper ; then
		HOSTNAMECOLOR='\[\e[01;34m\]'
	else
		HOSTNAMECOLOR='\[\e[01m\]'
	fi
	if $_isRS ; then
		USERCOLOR='\[\e[01;33m\]'
	elif $_ishopper ; then
		USERCOLOR='\[\e[01;34m\]'
	else
		USERCOLOR='\[\e[01m\]'
	fi

	if $_isEklient ; then
		if [[ -f /etc/lsb-release ]] ; then
			ps1host='ubuntu'
			ps1shorthost=''
		elif [[ -f /etc/debian_version ]] ; then
			ps1host='debian'
			ps1shorthost=''
		elif [[ -e /etc/fedora-release ]] ; then
			DTMP="$(grep nameserver /etc/resolv.conf)"
			export DISPLAY="${DTMP#nameserver }:1.0"
			if [[ $(grep 'Fedora release' /etc/fedora-release) ]] ; then
				ps1host='fedora'
				ps1shorthost=''
			elif [[ $(grep 'Generic release' /etc/fedora-release) ]] ; then
				ps1host='fedoraremix'
				ps1shorthost='remix'
			else
				ps1host='fedoraunknown'
				ps1shorthost='FU'
			fi
		else
			ps1host=$(hostname)
			ps1shorthost='U'
		fi
	else
		ps1host=$(hostname)
	fi
	if [ "$color_prompt" = yes ]; then
		PS1="${debian_chroot:+($debian_chroot)}$USERCOLOR\u\[\033[00m\]@$HOSTNAMECOLOR${ps1host}\[\033[00m\]: \[\033[01;34m\]\w\[\033[00m\]\$ "
	else
		PS1='${debian_chroot:+($debian_chroot)}\u@\h: \w\$ '
	fi
	unset color_prompt force_color_prompt HOSTNAMECOLOR USERCOLOR

	# If this is an xterm set the title to user@host:dir
	case "$TERM" in
		xterm*|rxvt*)
			#		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
			PS1="\[\e]0;${debian_chroot:+($debian_chroot)}$ps1shorthost \h: \w\a\]$PS1"
			;;
		*)
			;;
	esac

	# Use git prompt
	if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
		GIT_PROMPT_ONLY_IN_REPO=1
		source $HOME/.bash-git-prompt/gitprompt.sh
	fi

	# Set highligt in less
	# enter_standout_mode reverse
	export LESS_TERMCAP_so=$'\E[7m'
	#  exit_standout_mode normal
	export LESS_TERMCAP_se=$'\E[27m'
	# time format
	export TIME_STYLE=long-iso

	# Set up fzf key bindings and fuzzy completion
	if [[ -f $(command -v fzf)  ]] ; then
		export FZF_DEFAULT_OPTS='--height 100%'
		eval "$(fzf --bash)"
	fi
fi

# Default editor
    # export EDITOR='emacs -nw'
    export EDITOR='nvim'
    export VISUAL=$EDITOR

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
    if [ -t 1 ]; then
   	    cd ~
    fi
	# >>> conda initialize >>>
	# !! Contents within this block are managed by 'conda init' !!
	__conda_setup="$('/home/jb/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
	if [ $? -eq 0 ]; then
		eval "$__conda_setup"
	else
		if [ -f "/home/jb/miniconda3/etc/profile.d/conda.sh" ]; then
			. "/home/jb/miniconda3/etc/profile.d/conda.sh"
		else
			export PATH="/home/jb/miniconda3/bin:$PATH"
		fi
	fi
	unset __conda_setup
	# <<< conda initialize <<<

	PATH="/home/jb/perl5/bin${PATH:+:${PATH}}"; export PATH;
    PERL5LIB="/home/jb/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
	PERL_LOCAL_LIB_ROOT="/home/jb/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
	PERL_MB_OPT="--install_base \"/home/jb/perl5\""; export PERL_MB_OPT;
	PERL_MM_OPT="INSTALL_BASE=/home/jb/perl5"; export PERL_MM_OPT;

fi

if $_ist14s ; then
   # eval "$(/home/jonas/mambaforge/bin/conda shell.bash hook)"
   eval "$(/home/jonas/miniforge3/bin/conda shell.bash hook)"
fi


if $_isEklient; then
	:
fi

if $_isRS; then

	export CONDA_AUTO_ACTIVATE_BASE=false

	# >>> conda initialize >>>
	# !! Contents within this block are managed by 'conda init' !!
  	__conda_setup="$('/data/bnf/sw/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
	if [ $? -eq 0 ]; then
	eval "$__conda_setup"
	else
	if [ -f "/data/bnf/sw/miniconda3/etc/profile.d/conda.sh" ]; then
	. "/data/bnf/sw/miniconda3/etc/profile.d/conda.sh"
	else
	export PATH="/data/bnf/sw/miniconda3/bin:$PATH"
	fi
	fi
	unset __conda_setup
	# <<< conda initialize <<<

	 export TMUX_TMPDIR=$HOME/.local/tmp

:
fi

if $_ishopper; then
	 export TMUX_TMPDIR=$HOME/.local/tmp
    :
fi

