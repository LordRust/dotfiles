#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir="$HOME/dotfiles"                    # dotfiles directory
olddir="$HOME/dotfiles_old"             # old dotfiles backup directory
files="bash_aliases bash_profile bash_logout bashrc inputrc emacs tmux.conf dircolors gitconfig"    # list of files/folders to symlink in homedir
if [[ $1 == 'xserver' ]] ; then
	files="$files Xresources"
fi

# create dotfiles_old in homedir
if [[ ! -d "$olddir" ]] ; then
	echo "Creating $olddir for backup of any existing dotfiles in ~"
	mkdir -p "$olddir"
	echo "...done"
fi

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd "$dir" || exit
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
	src="$dir/$file"
	dst="$HOME/.$file"

	if [[ ! -e "$src" ]]; then
		echo "Skipping $file: source file not found."
		continue
	fi

	if [[ -e "$dst" || -L "$dst" ]]; then
		backup="$olddir/${file}_$(date +%Y%m%d%H%M%S)"
		echo "Backing up $dst to $backup"
		mv "$dst" "$backup"
	fi

	echo "Creating symlink $dst -> $src"
	ln -snf "$src" "$dst"
done

mkdir -p "$HOME/bin"
ln -snf "$dir/freemem.sh" "$HOME/bin/freemem.sh"
