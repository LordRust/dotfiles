# Load .profile, containing login, non-bash related initializations.
if [ -f ~/.profile ] ; then
    source ~/.profile
fi

# Load .bashrc, containing non-login related bash initializations.
if [ -f ~/.bashrc ] ; then
    source ~/.bashrc
fi

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
#if [ -n "$BASH_VERSION" ]; then
#    # include .bashrc if it exists
#    if [ -f "$HOME/.bashrc" ]; then
#        . "$HOME/.bashrc"
#    fi
#fi

# Always loaded environment variables
export PAGER=less
export LESS='RiMn'

_isbioinf=false
[[ "$(hostname -s)" =~ fbtserver|s-calc-fat01-p|s-sdi-calc[1..2]-p ]] && _isbioinf=true
[[ "$(whoami)" =~ jlr ]] && _isbioinf=true
_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true
_isosx=false
[[ "$(uname -s)" =~ Darwin ]] && _isosx=true
_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true
_iscygwin=false
[[ "$(uname -s)" =~ CYGWIN ]] && _iscygwin=true
_iscmd=false
[[ "$(hostname -s)" =~ MTLUCMDS1|mtlucmds2|MTLUCMDS2 ]] && _iscmd=true
_iscoco=false
[[ "$(hostname -s)" =~ coco ]] && _iscoco=true
_ishopper=false
[[ "$(hostname -s)" =~ rs-fs1|rs-fe1 ]] && _ishopper=true
_iswsl=false
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then _iswsl=true ; fi

#always complete cd with directories only
complete -d cd

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# host specific variables
if $_iswsl ; then
    # echo "this is WSL"
    export LIBGL_ALWAYS_INDIRECT=0
	export GDK_DPI_SCALING=1.25
	setxkbmap -model pc105 -layout us,se -option grp:ctrls_toggle
fi

if $_islinux ; then
   [[ (-e /usr/bin/neofetch) && (! -e $HOME/.config/neofetch/nosplash) ]] && neofetch --sixel $HOME/.config/neofetch/os.svg
fi

if $_isosx; then
    # Set architecture flags
    export ARCHFLAGS="-arch x86_64"
    # Ensure user-installed binaries take precedence
    export PATH=/usr/local/bin:/usr/local/sbin:$PATH:$HOME/bin
fi

if $_iscmd; then
	# export PATH="$HOME/.linuxbrew/bin:$HOME/.local/bin:$PATH"
	export PATH="$HOME/.local/bin:$PATH:/usr/local/go/bin"
	# export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
	# export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
	# source tab-qiime
	module load use.own
	# module load cmd
	# module load conda/miniconda3
fi

if $_isbioinf; then
	:
fi

if $_iscygwin; then
	# export LC_ALL=en_US.UTF-8:${LC_ALL}
	# export LANG=en_US.UTF-8:${LANG}
	export LANGUAGE=en
	# export LOCAL=Een_US.UTF-8:${LOCALE}
	# export LC_CTYPE=en_US.UTF-8:${LC_CTYPE}
	export DISPLAY=:0.0

fi

if $_iscoco; then
	## ssh-agent
	# Start ssh-agent to keep you logged in with keys, use `ssh-add` to log in
	agent=`pgrep ssh-agent -u $USER` # get only your agents
	if [[ "$agent" == "" || ! -e ~/.ssh/.agent_env ]]; then
		# if no agents or environment file is missing create a new one
		# remove old agents / environment variable files
		if [[ ! "$agent" == "" ]]; then
			kill $agent running
		fi
		if [[ -e ~/.ssh/.agent_env ]]; then
			rm ~/.ssh/.agent_env
		fi
		# restart
		# eval `ssh-agent`
		eval "$(ssh-agent -s)" > /dev/null
		ssh-add ~/.ssh/id_rsa_trinning
		ssh-add ~/.ssh/id_rsa_jtb
		ssh-add ~/.ssh/id_rsa
		echo 'export SSH_AUTH_SOCK'=$SSH_AUTH_SOCK >> ~/.ssh/.agent_env
		echo 'export SSH_AGENT_PID'=$SSH_AGENT_PID >> ~/.ssh/.agent_env
	fi

	# create our own hardlink to the socket (with random name)
	source ~/.ssh/.agent_env
	MYSOCK=/tmp/ssh_agent.${RANDOM}.sock
	ln -T $SSH_AUTH_SOCK $MYSOCK
	export SSH_AUTH_SOCK=$MYSOCK

	end_agent()
	{
		# if we are the last holder of a hardlink, then kill the agent
		nhard=`ls -l $SSH_AUTH_SOCK | awk '{print $2}'`
		if [[ "$nhard" -eq 2 ]]; then
			rm ~/.ssh/.agent_env
			ssh-agent -k
		fi
		rm $SSH_AUTH_SOCK
	}
	trap end_agent EXIT
	set +x

    #export PATH="/home/jb/anaconda3/bin:$PATH"
fi

if [[ "$(hostname -s)" =~ s-calc-fat01-p ]]; then

	export HOMEBREW_GITHUB_API_TOKEN=a04f9a35e9271724e0e9b0355aa849708d4896de

	#R libraries
	export R_LIBS_USER=${TOOLS}/lib/R

	#Language
	export LANG=${LANG}:en_US.UTF-8
	export LC_ALL=en_US.UTF-8

	#Python libraries
	#export PYTHONPATH=${PYTHONPATH}:${TOOLS}/git.repositories/LS-BSR

	export TZ="Europe/Copenhagen"
fi

if $_ishopper; then
	export LANG=en_US.UTF-8
fi


## Deduplicate PATHs 
get_var () {
    eval 'printf "%s\n" "${'"$1"'}"'
}
set_var () {
    eval "$1=\"\$2\""
}



cleanpath () {
	pathvar_name="$1"
	if [ -n "pathvar_name" ]; then
		pathvar_value=
		old_PATH="$(get_var "$pathvar_name"):"
		while [ -n "$old_PATH" ]; do
			x=${old_PATH%%:*}       # the first remaining entry
			case $pathvar_value: in
				*:"$x":*) ;;         # already there
				*) pathvar_value=$pathvar_value:$x;;    # not there yet
			esac
			old_PATH=${old_PATH#*:}
		done
		set_var $pathvar_name ${pathvar_value#:}	#strip the leading colon
		unset pathvar_value old_PATH x
	fi
}

cleanpath PATH
cleanpath INFOPATH
cleanpath MANPATH
