#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bash_aliases bash_profile bash_logout bashrc inputrc emacs tmux.conf dircolors gitconfig"    # list of files/folders to symlink in homedir
if [[ $1 == 'xserver' ]] ; then
	files="$files Xresources"
fi

# create dotfiles_old in homedir
if [[ ! -d $olddir ]] ; then
	echo "Creating $olddir for backup of any existing dotfiles in ~"
	mkdir -p $olddir
	echo "...done"
fi

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir || exit
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
		echo "Moving any existing dotfiles from ~ to $olddir"
	if [[ -f $file ]] ; then
		mv ~/."$file" ~/dotfiles_old/"$file"_"$(date +%Y%m%d%H%M)"
		echo "Creating symlink to $file in home directory."
	fi
done

ln -s $dir/freemem.sh ~/bin/freemem.sh
