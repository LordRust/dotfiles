_isbioinf=false
[[ "$(hostname -s)" =~ fbtserver|s-sdi-calc[1..5]-p ]] && _isbioinf=true
[[ "$(whoami)" =~ jlr ]] && _isbioinf=true
_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true # also includes Windows 10 - Ubuntu 
_isosx=false
[[ "$(uname -s)" =~ Darwin ]] && _isosx=true
_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true
_iscygwin=false
[[ "$(uname -s)" =~ CYGWIN ]] && _iscygwin=true
_iscmd=false
[[ "$(hostname)" =~ MTLUCMDS1|RS30090329|MTLUCMDS2|mtlucmds2 ]] && _iscmd=true

# Aliases for all platforms
alias s='cd ..'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -Cp'

alias sshl='ssh -Y zappa@lucifer.df.lth.se'
alias sshskalman='ssh -Y zappa@skalman.df.lth.se'
alias sshelaine='ssh -Y zappa@elaine.df.lth.se'
alias sshp='ssh zappa@pucko.df.lth.se'
alias sshssi='ssh -X -o ProxyCommand="ssh -W %h:%p osmc@cloud8.se" -p 19998 -l jlr localhost'
alias sshssi2='ssh -Y -o ProxyCommand="ssh -p 8080 -W %h:%p osmc@cloud8.se" -Cc aes128-cbc -p 19998 -l jlr localhost'
	
alias df='df -h'	

# platform specific aliases
if $_islinux||$_iscygwin ; then
	alias em='emacs -nw'
	alias emw='emacs'
	alias compc='compgen -A function -abck|grep'
	alias ls='ls -vCF --color=auto'
	alias parallel='parallel --gnu'
	alias sem='sem --gnu'
	alias gsed='sed'
	alias pdf2png='parallel "convert -verbose -density 150 -trim {} -quality 100 -sharpen 0x1.0 {.}.png" :::'
	alias aptupdate='sudo apt-get update && sudo apt-get upgrade'
	alias vboxfix='killall VBoxClient;VBoxClient-all'
	alias ct='column -t'
	function ctt() { column -ts $'\t' "$@" | less -S ; }
	alias go='gnome-open'
	alias tmux="TERM=screen-256color tmux"
	alias tmuxbusfix="source ~/bin/tmuxreconnect"
	alias sa='source activate'
	alias sd='source deactivate'
	alias st='sublime_text'
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
fi

# host specific aliases
if $_iscmd; then
   alias sshlennart="ssh -Y jonas@MTLUCMDS1.lund.skane.se"
   alias sshtrannel="ssh -Y jonas@10.0.224.64"
   alias sshcmddev="ssh -Y jonas@10.0.224.55"
   alias cdm="cd /data/bnf/proj/microbiology/"
   alias sshclarity='ssh root@mtapp046.lund.skane.se'
fi
if $_isbioinf; then
	alias rmiseq='rdesktop -u sbsuser -d HWI-M01940 -p sbs123 -r clipboard:PRIMARYCLIPBOARD -C -a 8 -g 1280x1024 10.30.6.40'
	alias sw='seaview -lengths'
	alias psj='ps -ajHfujlr|less'
	alias srvbion='ssh -X -p 2222 jlr@172.16.0.47'
	alias sshfat01='ssh -Y jlr@s-calc-fat01-p.ssi.ad'	
	alias sshcalc1='ssh -Y jlr@s-sdi-calc1-p.ssi.ad'
	alias sshcalc2='ssh -Y jlr@s-sdi-calc2-p.ssi.ad'
	alias sshcalc3='ssh -Y jlr@s-sdi-calc3-p.ssi.ad'
	alias sshcalc4='ssh -Y jlr@s-sdi-calc4-p.ssi.ad'
	alias sshcalc5='ssh -Y jlr@s-sdi-calc5-p.ssi.ad'
	alias sshce1='ssh -Y jlr@s-bionum-ce1-p'
	alias sftpliseq='sftp liseq@194.74.226.172:443'
	alias nasp='module unload nasp ; module load nasp ; nasp'
#	alias squeue='squeue -o "%.7i %.9P %.50j %.8u %.2t %.10M %.6D %R %m %c"'
	alias squeue='squeue -o "%8i %12u %.8M %30j %3t %12P %.5Q %.6m %2C %6E %13R" --sort=-S,p,i'
	alias srst2='module unload srst2 ;  module load srst2 ; srst2'
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
