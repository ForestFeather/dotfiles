#!/bin/bash

# Get our operational path
#SOURCE="${BASH_SOURCE[0]}"
SOURCE="$( cd "$( dirname "$0" )" && pwd )"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# function area
link_file() {
	source = "$SOURCE/$1"		# source file location.  $1 should be from the root of the git clone, which is found by execution of this script.
	target = "$HOME/$2"  		# target file location.  $2 should be the filename or path/filename from $HOME.
	if [ -e "${target}" ] && [ ! -L "${target}" ]; then
		# Found our target, aka it exists, and it's not already a link, so back it upi
		echo -n "Found existing item at ${target}, moving to ${target}.bak..."
		mv "${target}" "${target}.bak"
		echo "Done!"
	fi
	
	# Link file here
	ln -s "${source}" "${target}"
}

unlink_file() {
	target = "$HOME/$1"  		# target file location.  $1 should be the filename or path/filename from $HOME.
	if [ -e "${target}.bak" ] && [ ! -L "${target}.bak" ]; then
		# Found our target, aka it exists, and it's not already a link, so back it up
		echo -n "Found backup for ${target}, deleting ${target} and replacing backup to original location..."
		unlink "${target}"
		mv "${target}.bak" "${target}"
		echo "Done!"
	fi
}

# Set up directories
if [ ! -d "$HOME/scripts" ]; then
    mkdir "$HOME/scripts"
fi
if [ ! -d "$HOME/bin" ]; then
    mkdir "$HOME/bin"
fi
if [ ! -d "$HOME/.screen" ]; then
    mkdir "$HOME/.screen"
fi
if [ ! -d "$HOME/.git" ]; then
    mkdir "$HOME/.git"
fi
if [ ! -d "$HOME/.vim" ]; then
    mkdir "$HOME/.vim"
fi

# Set up bash links
bash_Arr=('profile' 'bash_profile' 'bashrc' 'bash_logout')
for LINK in ${bash_Arr[@]}; do
	echo "Linking .${LINK}..."
	link_file "bash/${LINK}" ".${LINK}"
done

# Set up vim


# Set up git


# Set up screen links


# Set up scripts


# Set up other items


# Generate ssh keys



