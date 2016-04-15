_isbioinf=false
[[ "$(hostname -s)" =~ fbtserver|s-sdi-calc1-p ]] && _isbioinf=true
[[ "$(whoami)" =~ jlr ]] && _isbioinf=true
_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true
_isosx=false
[[ "$(uname -s)" =~ Darwin ]] && _isosx=true
_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true


# Aliases for all platforms
alias s='cd ..'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

alias sshl='ssh -Y zappa@lucifer.df.lth.se'
alias sshskalman='ssh -Y zappa@skalman.df.lth.se'
alias sshelaine='ssh -Y zappa@elaine.df.lth.se'
alias sshp='ssh zappa@pucko.df.lth.se'
	
alias df='df -h'	

# platform specific aliases
if $_islinux; then
	alias emn='emacs -nw'
	alias em='emacs'
	alias compc='compgen -A function -abck|grep'
	alias ls='ls -CF --color=auto'
	alias parallel='parallel --gnu'
	alias sem='sem --gnu'
	alias gsed='sed'
	alias pdf2png='parallel "convert -verbose -density 150 -trim {} -quality 100 -sharpen 0x1.0 {.}.png" :::'
	alias aptupdate='sudo apt-get update && sudo apt-get upgrade'
	alias vboxfix='killall VBoxClient;VBoxClient-all'
	alias ct='column -t'
fi

# host specific aliases
if $_isbioinf; then
	alias rmiseq='rdesktop -u sbsuser -d HWI-M01940 -p sbs123 -r clipboard:PRIMARYCLIPBOARD -C -a 8 -g 1280x1024 10.30.6.40'
	alias rlicserv='rdesktop -u typning -d SSI -p typning2 -r clipboard:PRIMARYCLIPBOARD -g 1280x1024 MI-LICSERV-01'
	alias sw='/usr/local/bin/seaview'
	alias psj='ps -ajHfujlr|less'
	alias srvbion='ssh -X -p 2222 jlr@172.16.0.47'
	alias srvsshclc='ssh -X clcgenomics@172.16.0.22'
#	alias srvmnt='sshfs -o idmap=user $USER@172.16.0.22:/home/jlr ~/bioinf_server'
	alias srvssh='ssh -X jlr@172.16.0.22'
#	alias srvumnt='fusermount -u ~/bioinf_server'
	alias srvnew='ssh -X jlr@s-sdi-calc1-p.ssi.ad'
	alias sftpliseq='sftp liseq@194.74.226.172:443'
#	alias twix='/home/MPV/repos/production/ssi_scripts/twix/twix.py'
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
	alias sshosmc='ssh osmc@192.168.1.98' #OSMC

	alias em='~/Applications/Emacs.app/Contents/MacOS/Emacs'
	alias emn='~/Applications/Emacs.app/Contents/MacOS/Emacs -nw'
	alias finddisplay='ioreg -lw0 | grep IODisplayEDID | sed "/[^<]*</s///" | xxd -p -r | strings -6'
fi
