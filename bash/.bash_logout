#################################################################################
# FILE: ~/.bash_logout
# AUTHOR: Collin "Ridayah" O'Connor <ridayah@gmail.com>
# VERSION: 1.0.1
# Quite simply, when we exit a bash shell, run this.  Not hard at all.
#################################################################################

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
