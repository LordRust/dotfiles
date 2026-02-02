# Load .profile, containing login, non-bash related initializations.
if [ -f ~/.profile ] ; then
    source ~/.profile
fi

# Load .bashrc, containing non-login related bash initializations.
if [ -f ~/.bashrc ] ; then
    source ~/.bashrc
fi

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022


# Always loaded environment variables
export PAGER=less
export LESS='RiMn'

_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true
_isosx=false
[[ "$(uname -s)" =~ Darwin ]] && _isosx=true
_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true
_iscygwin=false
[[ "$(uname -s)" =~ CYGWIN ]] && _iscygwin=true
_iscmd=false
[[ "$(hostname -s)" =~ MTLUCMDS1|mtlucmds2|MTLUCMDS2|magrat ]] && _iscmd=true
_iscoco=false
[[ "$(hostname -s)" =~ coco ]] && _iscoco=true
_ishopper=false
[[ "$(hostname -s)" =~ rs-fs[1-2]|rs-fe1|rs-n[1-3] ]] && _ishopper=true
_iswsl=false
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then _iswsl=true ; fi
_isnixos=false
[[ "$(hostname -s)" =~ nixos ]] && _isnixos=true

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
	# the next line causes delays due to problems in the communication between
	# the xserver and the login script. This config can be in the xlaunch instead
	# setxkbmap -model pc105 -layout us,se -option grp:ctrls_toggle
fi

if $_islinux ; then
	# [[ (-e /usr/bin/neofetch) && (! -e $HOME/.config/neofetch/nosplash) && ($TERM == 'xterm-256color') ]] && neofetch --sixel $HOME/.config/neofetch/os.svg
	# [[ (-e /usr/bin/neofetch) && (! -e $HOME/.config/neofetch/nosplash) && ($TERM == 'xterm-256color') ]] && neofetch
	[[ ( $(which neofetch 2> /dev/null) != '' ) && (! -e $HOME/.config/neofetch/nosplash) && ($TERM == 'xterm-256color') ]] && neofetch
	[[ ( $(which fastfetch 2> /dev/null) != '' ) && (! -e $HOME/.config/fastfetch/nosplash) && ($TERM == 'xterm-256color') ]] && fastfetch -c $HOME/.config/fastfetch/config.jsonc
	if [ -n "$DISPLAY" ] && [ -f "$HOME/.Xresources" ]; then
		xrdb -cpp /usr/bin/cpp -merge "$HOME/.Xresources"
	fi
fi

if $_isnixos ; then
    # [[ ( $(which neofetch 2> /dev/null) != '' ) && (! -e $HOME/.config/neofetch/nosplash) && ($TERM == 'xterm-256color') ]] && neofetch
    :
fi

if $_isosx; then
    # Set architecture flags
    export ARCHFLAGS="-arch x86_64"
    # Ensure user-installed binaries take precedence
    export PATH=/usr/local/bin:/usr/local/sbin:$PATH:$HOME/bin
fi

if $_iscmd; then
	export PATH="$HOME/.local/bin:$PATH:/usr/local/go/bin"
	module load use.own
	# module load cmd
	# module load conda/miniconda3
fi

if $_iscygwin; then
	export LANGUAGE=en
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
