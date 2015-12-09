#!/bin/bash
#
# Updates dotfiles.  Intended to be run once per week on established systems.
# Author: Collin 'Ridayah' O'Connor <ridayah@gmail.com>
#############################################################################

cd ~/.dotfiles
git pull --all --verbose
bash setup.sh
