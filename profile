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
export LESS='iMn'

_isbioinf=false
[[ "$(hostname -s)" =~ fbtserver|s-sdi-calc1-p ]] && _isbioinf=true
[[ "$(whoami)" =~ jlr ]] && _isbioinf=true
_islinux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && _islinux=true
_isosx=false
[[ "$(uname -s)" =~ Darwin ]] && _isosx=true
_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true

#always complete cd with directories only
complete -d cd

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# host specific variables
if $_isosx; then
    # Set architecture flags
    export ARCHFLAGS="-arch x86_64"
    # Ensure user-installed binaries take precedence
    export PATH=/usr/local/bin:/usr/local/sbin:$PATH
fi

if $_isbioinf; then
#   # $HOME/.dropbox-dist/dropboxd & 2> /dev/null
    export SRST2_SAMTOOLS='/opt/bin/samtools-0.1.18'
    export SRST2_BOWTIE2='/opt/bin/bowtie2-2.2.4'
    export SRST2_BOWTIE2_BUILD='/opt/bin/bowtie2-build-2.2.4'
    export R_LIBS_USER='/opt/libs/R'
fi

if [[ "$(hostname -s)" =~ s-sdi-calc1-p ]]; then

#   PATH=$HOME/byobu/bin:$PATH:/opt/bin:/opt/brew/bin:/opt/brew/sbin:$HOME/.local/bin:$HOME/bin
   PATH=$PATH:/opt/bin:/opt/brew/bin:/opt/brew/sbin:$HOME/.local/bin:$HOME/bin
   export BYOBU_PREFIX=$(brew --prefix)

   # LANGUAGE
   export LANG=en_US.UTF-8:$LANG
   export LC_ALL=en_US.UTF-8 

   # PERL modules
   eval "$(perl -I/opt/lib/perl5/lib/perl5 -Mlocal::lib=/opt/lib/perl5/)"
fi
