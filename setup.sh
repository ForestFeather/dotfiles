#!/bin/sh

# Set up directories
if [ ! -d "$HOME/scripts" ]; then
    mkdir "$HOME/scripts"
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
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

ln -s 

# Set up vim


# Set up git


# Set up screen links


# Set up scripts


# Set up other items


# Generate ssh keys



