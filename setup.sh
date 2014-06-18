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
	SRC="$SOURCE/$1"		# source file location.  $1 should be from the root of the git clone, which is found by execution of this script.
	TGT="$HOME/$2"  		# target file location.  $2 should be the filename or path/filename from $HOME.
	if [ -e "${TGT}" ] && [ ! -L "${TGT}" ]; then
		# Found our target, aka it exists, and it's not already a link, so back it upi
		echo -n "Found existing item at ${TGT}, moving to ${TGT}.bak..."
		mv "${TGT}" "${TGT}.bak"
		echo "Done!"
	fi
	
	# Link file here
	if [ ! -e "${TGT}" ]; then 
		echo -n "Linking ${TGT}..."
		ln -s "${SRC}" "${TGT}"
		echo "Done!"
	else
		echo "${TGT} was already a link, skipping."
	fi
}

unlink_file() {
	TGT="$HOME/$1"  		# target file location.  $1 should be the filename or path/filename from $HOME.
	if [ -e "${TGT}.bak" ] && [ ! -L "${TGT}.bak" ]; then
		# Found our target, aka it exists, and it's not already a link, so back it up
		echo -n "Found backup for ${TGT}, deleting ${TGT} and replacing backup to original location..."
		unlink "${TGT}"
		mv "${TGT}.bak" "${TGT}"
		echo "Done!"
	fi
}

# Set up directories
foldersArr=(scripts bin .ssh .screen .vim '.vim/colors' '.vim/bundles' '.vim/plugins' .tmux .git Applications Documents Downloads DUMP Movies Music Pictures Projects Sites Landfill)
echo "Creating directories."
for LINK in ${foldersArr[@]}; do
	if [ ! -d "$HOME/$LINK" ]; then
		echo -n "Directory $LINK doesn't exist, creating..."
		mkdir "$HOME/$LINK"
		echo "Done!"
	fi
done
echo "Directories created."

# Set up bash links
bash_Arr=('profile' 'bash_profile' 'bashrc' 'bash_logout')
echo "Creating BASH shell links."
for LINK in ${bash_Arr[@]}; do
	#echo "Linking .${LINK}..."
	link_file "bash/${LINK}" ".${LINK}"
done
echo "BASH shell links created."

# Set up vim
vimArr=('colors/grb256.vim')
echo "Creating vim shell links."
link_file "configs/vim/vimrc" ".vimrc"
for LINK in ${vimArr[@]}; do
	link_file "configs/vim/${LINK}" ".vim/${LINK}"
done


echo "Vim shell links created."

# Set up git
git_Arr=('gitignore' 'gitconfig' 'gitmodules')
echo "Creating Git shell links."
for LINK in ${bash_Arr[@]}; do
    #echo "Linking .${LINK}..."
    link_file "configs/git/${LINK}" ".${LINK}"
done
echo "Git shell links created."

# Set up screen links


#set up tmux
tmuxArr=('sbs' '3s' '3e' )
echo "Setting up tmux related files..."
for LINK in ${tmuxArr[@]}; do
    link_file "configs/tmux/${LINK}" ".tmux/${LINK}"
done
echo "Tmux setup completed."

# Set up scripts
echo "Setting up script links."
for LINK in `ls scripts | xargs -n 1 basename`; do
	link_file "scripts/${LINK}" "scripts/${LINK}"
done
echo "Script links created."

# Set up other items
miscArr=("dir_colors" "tmux.conf")
echo "Setting up miscellaneous configuration file links."
for LINK in ${miscArr[@]}; do
        #echo "Linking .${LINK}..."
        link_file "configs/${LINK}" ".${LINK}"
done
echo "Miscellaneous configuration file links created."

# Generate ssh keys/setup ssh
echo "Beginning SSH setup."
if [ ! -e ~/.ssh/id_dsa ]; then
	echo "No existing SSH key found, generating new keys..."
	ssh-keygen -t dsa -N "" -f ~/.ssh/id_dsa
	echo "SSH key generation done."
else
	echo "Existing id_dsa found, skipping SSH key generation."
fi
echo "Setting up ssh configuration files."
sshArr=('config' 'authorized_keys2')
for LINK in ${sshArr[@]}; do
        link_file "configs/ssh/${LINK}" ".ssh/${LINK}"
done

echo "SSH setup completed."

