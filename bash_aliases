_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true # also includes Windows 10 - Ubuntu 
_isosx=false
[[ "$(uname -s)" =~ Darwin ]] && _isosx=true
_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true
_iscygwin=false
[[ "$(uname -s)" =~ CYGWIN ]] && _iscygwin=true
_iscmd=false
[[ "$(hostname)" =~ MTLUCMDS1|RS30134699|RS30134650|RS30090329|RS30106828|RS30135183|MTLUCMDS2|mtlucmds2|rs-fs1|rs-fe1|magrat ]] && _iscmd=true
_ishopper=false
[[ "$(hostname -s)" =~ rs-fs[1-2]|rs-fe1|rs-n[1-3] ]] && _ishopper=true
_isnixos=false
[[ "$(hostname -s)" =~ nixos ]] && _isnixos=true
_iscoco=false
[[ "$(hostname -s)" =~ t14s ]] && _iscoco=true

# Aliases for all platforms
alias s='cd ..'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -Cp'

alias sshl='ssh -Y zappa@lucifer.df.lth.se'
alias sshskalman='ssh -Y zappa@skalman.df.lth.se'
alias sshelaine='ssh -Y zappa@elaine.df.lth.se'
alias sshp='ssh zappa@pucko.df.lth.se'

alias df='df -h'
alias bc='bc -lq'

# platform specific aliases
if $_islinux||$_iscygwin ; then
    alias please='sudo $(history -p \!\!)'
    alias zzvmstat='vmstat -w -a -S M 2'
    alias zziostat='iostat -m -N -y 2'
	alias zzdropcaches='sudo sh -c “echo 3 > /proc/sys/vm/drop_caches”'
	alias em='emacs -nw'
	alias emw='emacs'
	if [[ ( $(which nvim 2> /dev/null) != '' ) ]] ; then
		alias vi='nvim'
		alias vim='nvim'
	fi
	alias compc='compgen -A function -abck|grep'
	alias ls='ls -vCF --color=auto'
	alias parallel='parallel --gnu'
	alias sem='sem --gnu'
	alias gsed='sed'
	alias pdf2png='parallel "convert -verbose -density 150 -trim {} -quality 100 -sharpen 0x1.0 {.}.png" :::'
	alias aptupdate='sudo apt-get update && sudo apt-get upgrade'
	alias vboxfix='killall VBoxClient;VBoxClient-all'
	alias mamba-envs='active_mamba_path=$(which mamba | sed "s/\/bin\/mamba//"); active_envs_path="$active_mamba_path/envs"; mamba env list | grep "$active_envs_path"'
	function ct() { column -tns $'\t' "$@" ; }
	function ctt() { column -tns $'\t' "$@" | less -S ; }
	function bless() { iconv -f iso-8859-1 -t UTF-8 "$@" | less; }
	function bcat() { iconv -f iso-8859-1 -t UTF-8 "$@"; }
	# alias go='gnome-open'
	alias tmux="TERM=screen-256color tmux"
	alias bfix="source ~/bin/tmuxreconnect"
	alias sa='conda activate'
	alias sd='conda deactivate'
	alias ma='mamba activate'
	alias md='mamba deactivate'
	alias fz='history|fzf'
	alias findrecurserev='find . -type f -printf "%T+ %p\n" | sort -n'
	alias running_services='systemctl list-units  --type=service  --state=running'
	alias x11keyboard='setxkbmap -model pc105 -layout us,se -option grp:ctrls_toggle'
	alias xc='xclip -se c'
	alias imsi='img2sixel'
	function idletty()
	{
		who -s | awk '{ print $2 }' | \
			(cd /dev && xargs stat -c '%n %U %X') | \
			awk '{ print $1"\t"$2"\t"('"$(date +%s)"'-$3)/60 }' | \
			sort -n -r -k 3
	}
	function pidtime()
	{
   		for i in "$@"
   	do
		for j in $(pidof $i)
      		do
			echo
         		echo $i pid $j
      			ps -p $j -o etime
      		done
   	done
	}
	function body() {
	    IFS= read -r header
	    printf '%s\n' "$header"
	    "$@"
	}
fi

# host specific aliases
if $_iscmd; then
   alias sshlennart="ssh -Y jonas@MTLUCMDS1.lund.skane.se"
   alias sshtrannel="ssh -Y jonas@mtlucmds2.lund.skane.se"
   alias sshcmddev="ssh -Y jonas@10.0.224.55"
   alias cdm="cd /data/bnf/proj/microbiology/"
   alias sshclarity='ssh clarity@claritylims.lund.skane.se'
   alias sshclaritytest='ssh root@clarity-test.lund.skane.se'
   alias sshfe1prox='ssh -o ProxyCommand="ssh -W %h:%p jonas@mtlucmds1.lund.skane.se" jonas@rs-fe1.lunarc.lu.se'
   alias sshfs1prox='ssh -o ProxyCommand="ssh -W %h:%p jonas@mtlucmds1.lund.skane.se" jonas@rs-fs1.lunarc.lu.se'
   alias sshfe1='ssh -Y rs-fe1.lunarc.lu.se'
   alias sshfs1='ssh -Y rs-fs1.lunarc.lu.se'
   alias nfq='sudo /fs1/bjorn/bnf-scripts/nfq'
   alias jbmamba='source ~/share/jbmamba.sh'
   alias squeue='squeue -o "%7i %7u %.8M %.10l %20j %2t %.8M %7P %.5Q %.5m %2C %19S %6E %13R" --sort=-S,p,i'
   alias squeuelong='squeue -o "%7i %7u %.8M %.10l %55j %2t %13P %.5Q %.5m %2C %19S %6E %R" --sort=-S,p,i'
   alias psj='ps -ajHfu jonas|less'
   # alias squeue='squeue -o "%8i %12u %.8M %30j %3t %12P %.5Q %.6m %2C %6E %13R" --sort=-S,p,i'

   # lfsscp(){
   #      scp -o ProxyCommand="ssh -W %h:%p rs-fs1.lunarc.lu.se" -P 22022 $1 lfs603.srv.lu.se:$2
   # 		}
   # alias lfsssh='ssh -o ProxyCommand="ssh -W %h:%p rs-fs1.lunarc.lu.se" -p 22022 lfs603.srv.lu.se'
fi

if $_ishopper ; then
	function ct() { column -ts $'\t' "$@" ; }
   	function ctt() { column -ts $'\t' "$@" | less -S ; }
fi

if $_iscoco ; then
	function ct() { column -ts $'\t' "$@" ; }
   	function ctt() { column -ts $'\t' "$@" | less -S ; }
fi

if $_isosx; then
	alias ls='ls -GCF'
	alias ll='ls -alGFh'
	alias la='ls -GA'
	alias l='ls -GCF'


	alias sshk='ssh -Y jonas@10.0.1.201'
	alias sshmk64='ssh 101565_mk64@ssh.binero.se'
	alias sshtv='ssh root@Apple-TV.local'
	alias sshretropi='ssh pi@192.168.1.98' #raspberry
	alias sshosmc='ssh osmc@cloud8.se' #OSMC

	alias em='emacs'
	alias emn='emacs -nw'
	alias finddisplay='ioreg -lw0 | grep IODisplayEDID | sed "/[^<]*</s///" | xxd -p -r | strings -6'
fi
