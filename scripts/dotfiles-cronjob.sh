#!/bin/bash
#
# Setup to manage the dotfiles script auto-updater
# Author: Collin 'Ridayah' O'Connor
# Date: 10/25/16 9:22AM
#######################################################

croncmd="~/scripts/update-dotfiles.sh >/dev/null 2>&1"
job="0 3 */7 * * $croncmd"
( crontab -l | grep -v -F "$croncmd"; echo "$job" ) | crontab -

