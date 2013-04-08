#################################################################################
# FILE: ~/.bashrc
# AUTHOR: Collin "Ridayah" O'Connor <ridayah@gmail.com>
# VERSION: 2.0.4
# NOTES: Gods, this thing started as a plain default Gentoo based .bashrc but
# after years of accumulating functions and scripts and who knows what else I'm
# rewriting it to be a LOT more sensible.  I'm sick and tired of searching this
# thing when something needs updating or whatever, so I'm finally gonna make
# a lot more sense of it. Broken up into various areas for convienience.
# If I think of anything I'll add it.
#
# Special thanks go out to script authors, noted from who where possible..
#################################################################################

#################################################################################
# INTERACTIVE TEST
# 
# Testing to see if the shell is interactive.  If not it can cause problems, so
# in that case we exit out before anything is done. Safety first ladies and lads!
#################################################################################

if [[ $- != *i* ]]; then
	return
fi



#################################################################################
# SOURCE MAJOR FILES
#
# Since each system might have dependent functions, and soforth, and each user
# directory may have its own aliases and whatever... let's get them.  Although
# they're probably pretty basic IF they exist, so odds are whatever is in them
# will wind up overwritten.
#################################################################################

# First, global bashrc. 
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Second, local bashrc.
if [ -f ~/.bashrc.local ]; then
	. ~/.bashrc.local
fi

# Third, bash profile.
#if [ -f ~/.bash_profile ]; then
#	. ~/.bash_profile
#fi

# Fourth, local bash alias file.  Although why anyone would use this is beyond me.
if [ -f ~/.bash_alias ]; then
	. ~/.bash_alias
fi



#################################################################################
# COLORS
#
# Colors that get used in various places.  Useful!  We also source our dir_colors
# if we find they exist.
#################################################################################

NO_COLOR="\[\033[0m\]"
BLACK="\[\033[0;30m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
MAGENTA="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
OFFWHITE="\[\033[0;37m\]"
LIGHT_BLACK="\[\033[1;30m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_YELLOW="\[\033[1;33m\]"
LIGHT_BLUE="\[\033[1;34m\]"
LIGHT_MAGENTA="\[\033[1;35m\]"
LIGHT_CYAN="\[\033[1;36m\]"
WHITE="\[\033[1;37m\]"

# dir_colors time!
if [ -f ~/.dir_colors ]; then
	eval `dircolors -b ~/.dir_colors`
elif [ -f /etc/DIR_COLORS ]; then
	eval `dircolors -b /etc/DIR_COLORS`
else
	eval `dircolors -b`
fi

#################################################################################
# VARIABLES
#
# Important (and not so important) variables.  Many of these get used only once,
# and some are just included just because.  But you never know when you'll need
# them and it's best to have them all here first.
#################################################################################

# Simple Current Variables.
HOSTNAM=$(hostname)
USERNAM=$(whoami)
CURRDATE=$(date)
DISTRIBUTION=''
PKG_MNGR=''
# For Distribution.
if [ -f /etc/arch-release ]; then
        PKG_MNGR='Pacman'
        DISTRIBUTION='Arch Linux'
elif [ -f /etc/mandriva-release ]; then
        PKG_MNGR='urpmi'
        DISTRIBUTION='Mandriva'
elif [ -f /etc/yellowdog-release ]; then
        PKG_MNGR='Yum'
        DISTRIBUTION='Yellow Dog'
elif [ -f /etc/gentoo-release ]; then
        PKG_MNGR='Emerge'
        DISTRIBUTION='Gentoo'
elif [ -f /etc/knoppix_version ]; then
        PKG_MNGR='APT'
        DISTRIBUTION='Knoppix'
elif [ -f /etc/slackware-version ]; then
        PKG_MNGR='Slackpkg'
        DISTRIBUTION='Slackware'
elif [ -f /etc/SuSE-release ]; then
        PKG_MNGR='Zypper'
        DISTRIBUTION='SuSE Linux'
elif [ -f /etc/mandrake-release ]; then
        PKG_MNGR='urpmi'
        DISTRIBUTION='Mandrake'
elif [ -f /etc/fedora-release ]; then
        PKG_MNGR='Yum'
        DISTRIBUTION='Fedora'
elif [ -f /etc/redhat-release ]; then
        PKG_MNGR='Yum'
        DISTRIBUTION='RedHat'
elif [ -f /etc/lsb-release ]; then
        PKG_MNGR='APT'
        DISTRIBUTION='Ubuntu'
elif [ -f /etc/debian_version ]; then
        PKG_MNGR='APT'
        DISTRIBUTION='Debian'
else
	DISTRIBUTION='UNKNOWN' 
fi

#################################################################################
# PROMPT
#
# We HAVE to have a pretty pretty prompt.  Now let's get to it, damnit.
#################################################################################

# Let's set this.  Our Prompt command for various terms.
case $TERM in
	xterm*|rxvt*|Eterm)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
esac

# Now let's set our titlebar!
case $TERM in
	xterm*|rxvt* )
		TITLEBAR='\[\033]0;\u@\h:\w\007\]'
		;;
	* )
		TITLEBAR=""
		;;
esac

# Finally, our terminal prompt.
PS1="$LIGHT_GREEN\u@\h$WHITE:$LIGHT_CYAN\w $WHITE$>$NO_COLOR"

# In case I switch it, for whatever reason.
function basicprompt () {
	PS1="$LIGHT_GREEN\u@\h$WHITE:$LIGHT_CYAN\w $WHITE$>$NO_COLOR"
	PS2="$WHITE->$NO_COLOR"
}

# Including this for completeness, I once used this but it sucked donkey butt.
# Requires the hostnam and usernam variables above.
function prompt_command {
	TERMWIDTH=${COLUMNS}
	#tempdate=$(date "+%A, %b %d %r")
	memavail=$(memavailable)
	lsbytes=$(lsbytesum)
	temp="---< ${USERNAM}@${HOSTNAM} >---< ${memavail} >---< ${lsbytes} >---< ${PWD} >---"
	let fillsize=${TERMWIDTH}-${#temp}
	if [ "$fillsize" -gt "0" ]; then
		fill="───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────"
		fill="${fill:0:${fillsize}}"
		newPWD="${PWD}"
	fi
	
	if [ "$fillsize" -lt "0" ]
	then
		fill=""
		let cut=3-${fillsize}
		newPWD="...${PWD:${cut}}"
	fi
}

PROMPT_COMMAND=prompt_command

function longprompt () {
	PS1="$LIGHT_BLUE╟$LIGHT_CYAN─$LIGHT_GREEN─╢$WHITE \${USERNAM}$LIGHT_GREEN@$WHITE\${HOSTNAM} $LIGHT_GREEN╟─$LIGHT_CYAN─$LIGHT_GREEN─╢$WHITE \${memavail}"
	PS1=$PS1" $LIGHT_GREEN╟─$LIGHT_CYAN─$LIGHT_GREEN─╢$WHITE \${lsbytes} $LIGHT_GREEN╟─$LIGHT_CYAN─\${fill}$LIGHT_GREEN─╢$WHITE \${newPWD} $LIGHT_GREEN╟─"
	PS1=$PS1"$LIGHT_CYAN─$LIGHT_BLUE╢\n$LIGHT_BLUE╟$LIGHT_CYAN─$LIGHT_GREEN─╢$WHITE \$ $LIGHT_GREEN> $NO_COLOR"
	PS2="$LIGHT_BLUE─$LIGHT_CYAN─$LIGHT_GREEN─╢ $NO_COLOR"
}

# This isn't too bad.  Used instead of above; allows us to replace our current
# prompt's pwd with one that is automatically shortened.
#function prompt_command {
#	#   How many characters of the $PWD should be kept
#	local pwdmaxlen=30
#	#   Indicator that there has been directory truncation:
#	#trunc_symbol="<"
#	local trunc_symbol="..."
#	if [ ${#PWD} -gt $pwdmaxlen ]
#	then
#		local pwdoffset=$(( ${#PWD} - $pwdmaxlen ))
#		newPWD="${trunc_symbol}${PWD:$pwdoffset:$pwdmaxlen}"
#	else
#		newPWD=${PWD}
#	fi
#}
#PROMPT_COMMAND=prompt_command

case $TERM in
	*rxvt* | putty | *xterm* | screen ) longprompt ;;
	*) basicprompt ;;
esac

#################################################################################
# EXPORTS
# 
# Okay, so there's stuff that needs exporting.  Like various settings!  So let's
# hop to it damnit!
#################################################################################

export HISTFILE=~/.bash_history
export HISTSIZE=10000
export HISTCONTROL=ignoreboth
export HISTIGNORE="l:ll:llt:cdb:b:r:exit:env:date:.:..:...:....:.....:pwd:cfg:rb:eb:!!:ls:fg:bg:cd ..:h:mc"
export EDITOR=vim
export PAGER=less
export LESS='-R -i'				# Show raw characters, ignore case
export LESSOPEN='| lesspipe %s 2>&-'		# Only if lesspipe exists.
export BROWSER='firefox'
export LANG=en_US.UTF-8
#export GIT_CURL_VERBOSE=1

# Path checking.
export PATH=$PATH:./bin
if [ -x $HOME/bin ]; then
	export PATH=$PATH:$HOME/bin
fi
if [ -x $HOME/scripts ]; then
	export PATH=$PATH:$HOME/scripts
fi
if [ -x $HOME/programs ]; then
	export PATH=$PATH:$HOME/programs
fi

# color in man pages http://icanhaz.com/colors
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#################################################################################
# SET/SHOPT/COMPLETE OPTIONS
#
# These are mighty useful, setting terminal options and controls.
#################################################################################

shopt -s cdable_vars
shopt -s cdspell
shopt -s checkhash
shopt -s cmdhist
shopt -s checkwinsize
shopt -s dotglob
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete
shopt -s lithist
shopt -s no_empty_cmd_completion
shopt -s progcomp
shopt -s sourcepath

shopt -u mailwarn

set -o notify
set -o noclobber
set -o ignoreeof
set +o nounset

stty -ixon				# disable XON/XOFF flow control (^s/^q) 
complete -cf sudo			# Tab complete for sudo

complete -A hostname   rsh rcp telnet rlogin r ftp ping disk
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su mail finger

complete -A helptopic  help     # currently same as builtins
complete -A shopt      shopt
complete -A stopped -P '%' bg
complete -A job -P '%'     fg jobs disown

complete -A directory  mkdir rmdir
complete -A directory   -o default cd

# Now I don't actually use these because I've found them to be annoying,
# But I'll add them for completeness sake just commented out.
# Compression
#complete -f -o default -X '*.+(zip|ZIP)'  zip
#complete -f -o default -X '!*.+(zip|ZIP)' unzip
#complete -f -o default -X '*.+(z|Z)'      compress
#complete -f -o default -X '!*.+(z|Z)'     uncompress
#complete -f -o default -X '*.+(gz|GZ)'    gzip
#complete -f -o default -X '!*.+(gz|GZ)'   gunzip
#complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
#complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2
# Postscript,pdf,dvi.....
#complete -f -o default -X '!*.ps'  gs ghostview ps2pdf ps2ascii
#complete -f -o default -X '!*.dvi' dvips dvipdf xdvi dviselect dvitype
#complete -f -o default -X '!*.pdf' acroread pdf2ps
#complete -f -o default -X '!*.+(pdf|ps)' gv
#complete -f -o default -X '!*.texi*' makeinfo texi2dvi texi2html texi2pdf
#complete -f -o default -X '!*.tex' tex latex slitex
#complete -f -o default -X '!*.lyx' lyx
#complete -f -o default -X '!*.+(htm*|HTM*)' lynx
# Multimedia
#complete -f -o default -X '!*.+(jp*g|gif|xpm|png|bmp)' xv gimp
#complete -f -o default -X '!*.+(mp3|MP3)' mpg123 mpg321
#complete -f -o default -X '!*.+(ogg|OGG)' ogg123

#complete -f -o default -X '!*.pl'  perl perl5



#################################################################################
# DISTRO/OS DEPENDENT FUNCTIONS AND ALIASES
#
# Since I work on a number of different distributions, it's fairly useful to find
# out which one I'm working on and have certain aliases ready for it.  Of course,
# since I only use Gentoo or Debian systems at this time there is no point for
# specifying variables for that.  I could also expand this to include different
# OS systems but since I only use linux, that's pointless but you could do this
# for *BSD, Cygwin, and so on various systems that support bash.
#################################################################################

# Package Management Aliases.
case $PKG_MNGR in
	APT )
                alias add='sudo apt-get install -y'
                alias fix='sudo apt-get install -f -y'
                alias remove='sudo apt-get remove -y'
                alias update='sudo apt-get update -y'
                alias upgrade='sudo apt-get upgrade -y'
                alias expunge='sudo apt-get clean -y'
                alias flush='sudo apt-get autoremove -y'
	;;
	Emerge )
                alias emerge='sudo emerge'
                alias esearch='esearch -S'
                alias etc-update='sudo etc-update'
                alias etcupdate="etc-update"
	;;
	Pacman )
		alias pacup='sudo pacman -Syu'            # sync and update
		alias pacin='sudo pacman -S'              # install pkg
		alias pacout='sudo pacman -Rns'           # remove pkg and the deps it installed
		alias pacs="pacman -Sl | cut -d' ' -f2 | grep " #
		alias pacman='sudo pacman'
		alias pac="pacsearch"                     # colorize pacman (pacs)
		pacsearch () 
		{
  			echo -e "$(pacman -Ss $@ | sed \
  			-e 's#core/.*#\\033[1;31m&\\033[0;37m#g' \
  			-e 's#extra/.*#\\033[0;32m&\\033[0;37m#g' \
  			-e 's#community/.*#\\033[1;35m&\\033[0;37m#g' \
  			-e 's#^.*/.* [0-9].*#\\033[0;36m&\\033[0;37m#g' )"
		}
	;;
	urpmi )
		alias urpmi='sudo urpmi --no-clean'
	;;
	Yum )
		alias yum='sudo yum'
		alias update='yum update'
		alias updatey='yum -y update'
	;;
	Slackpkg )
		alias installpkg="sudo installpkg"
		alias removepkg="sudo removepkg"
		alias slackpkg="sudo slackpkg"
		alias upgradepkg="sudo upgradepkg"
	;;
	Zypper )
		alias zypper='sudo zypper'
		alias z='zypper'               	             # Alias for zypper
		alias zinr='zypper -v inr'                   # Zypper install new recommends
		alias zin='zypper -v install'                # Zypper install
		alias zref='zypper refresh'                  # Zypper refresh repos
		alias zrm='zypper -v remove'                 # Zypper remove PACKAGE
		alias zup='zypper -v update'                 # Zypper update
		alias zdup='zypper -v dist-upgrade --no-recommends'	# Zypper distribution upgrade, do not install recommended packages, only required
		alias zpchk='zypper -v patch-check'                    	# Zypper patch check
		alias zse='zypper -v se'                        	# Zypper search for packages matching given search strings
		alias zsee='z -v se --match-any --search-descriptions --details'	# Special search  
		alias zar='zypper ar -f -r'                  # Zypper addrepo enable autorefresh of the repository.
		alias zcl='zypper -v clean'                  # Clean zypper cache
	;;
	* )
	;;
esac
	
# Case statement.
case $DISTRIBUTION in
	Debian )
	;;
	Gentoo )
	;;
	SuSE )
	;;
	Mandrake )
	;;
	RedHat )
	export PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH"
	;;
	* )
	;;
esac



#################################################################################
# COMPUTER DEPENDENT FUNCTIONS AND ALIASES
#
# Dundundun
#################################################################################

#Add in...
case $HOSTNAM in
	cesal )
		# Aliases
		alias mainscreen="screen -c ~/.screen/screenrc -S irssi"
		alias shellscreen="screen -c ~/.screen/shellscreen -S shells"
		alias muckscreen="screen -c ~/.screen/muckscreen -S mucks"
		alias sshscreen="screen -c ~/.screen/sshscreen -S ssh"
		alias screenon="screen -rAax irssi"
		alias ncmpc="ncmpc -c"

		# Functions
		# DOES NOT WORK
		# Currently testing. This will make a check; if screen is not currently running it launches it.
		#if [ screen -ls | egrep '^[[:space:]]+[^[:space:]]' | awk '{print $1}' | egrep '.irssi$' ]; then
		#	#DO NOT RUN THIS HERE:screen -c ~/.screen/screenrc -S irssi -t irssi
		#	return
		#else
		#	screen -c ~/.screen/screenrc -S irssi
		#fi

	;;
	aquinor )
		# Aliases
		alias lely="telnet localhost 1363"
		alias avinar="telnet localhost 1364"
		alias screenon="screen -S screen"
		alias screenresume="screen -rAax screen"

		# Functions

	;;
	* )
	;;
esac



#################################################################################
# GLOBAL ALIASES AND FUNCTIONS
#
# Now for our global aliases and functions!
#################################################################################

# Aliases
# These aliases don't require functions.  More aliases appear but they are down
# with their associated functions.
#################################################################################

# SSH Aliases
alias uwsuper="ssh coconno3@linux.uwsuper.edu"
alias cs2="ssh coconno3@cs2.uwsuper.edu"
alias awswan="ssh whitedrake@whitedrake.awswan.com"
alias aquinor="ssh -p 3764 ridayah@whitedrake.homelinux.net"

# Muck Aliases
alias alfandria="tf -f~/.tf/Alfandria"
alias frostfire="tf -f~/.tf/FrostFire"
alias tapestries="tf -f~/.tf/Taps"
alias tapslely="tf -f~/.tf/LelyTaps"
alias spheresmux="tf -f~/.tf/Spheres"
alias scalesmuck="tf -f~/.tf/Scales"
alias taillog="tail -n 30 -f /var/log/messages"

# Screen aliases
alias screen="screen -U"
alias screenon="screen -c $HOME/.screen/screenrc -S Default"
alias minscreen="screen -c $HOME/.screen/minscreenrc -S Default"
alias resumescreen="screen -rAax Default"

# Command Aliases
alias grep="grep --color=auto"
alias ping="ping -c 5"
alias pgrep="ps -aux | grep $1"
alias traillog="taillog"
alias path='echo "$PATH"'
alias tgz='tar -cvvzf'
alias tbz2='tar -cvvjf'
alias mktar='tar -cvvf'
alias untar='tar -xvvf'
alias utgz='tar -xvvzf'
alias utbz2='tar -xvvjf'
alias dict="dict -d english -s word -P 'less -q'"
alias ls="ls --color=always"
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
alias mkdir='mkdir -p'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -la'
alias lsd='ls -d */'
alias lx='ls -XB'					# sort by extension
alias lk='ls -Sr'					# sort by size
alias lc='ls -cr'					# sort by change time
alias lu='ls -ur'					# sort by access time
alias lt='ls -tr'					# sort by date
alias llx='ls -lXB'					# long sort by extension
alias llk='ls -lSr'					# long sort by size
alias llc='ls -lcr'					# long sort by change time
alias llu='ls -lur'					# long sort by access time
alias llt='ls -ltr'					# long sort by date
alias lcd='cd "$1" && ls'
alias ns="netstat -alnp --protocol=inet | grep -v CLOSE_WAIT | cut -c-6,21-94 | tail +2"
alias da='date "+%Y-%m-%d %A %T %Z”"'
alias filesizes="du -sk * | sort -n | perl -ne '(\$s,\$n)=split(m{\t});for (qw(B KB MB GB)) {if(\$s1024) {print \"\$s\$_\t\$n\"; last};\$s=\$s/1024}'"
alias dos2unix="perl -pi -e 's/\r\n/\n/;'"
alias unix2dos="perl -pi -e 's/\n/\r\n/;'"
alias update-time="sudo ntpdate pool.ntp.org"



# Simple Functions
#
# Nice, simple, easy to understand functions.  Just wait til later...
#################################################################################

# Very VERY important, must not forget keychain.
# ssh keymanager
if [ -e /usr/bin/keychain ]; then
	keychain -q ~/.ssh/id_dsa
	if [ -e ~/.ssh-agent-${HOSTNAME} ]; then
		. ~/.ssh-agent-${HOSTNAME}
	fi
	if [ -e ~/.keychain/${HOSTNAME}-sh ]; then
		. ~/.keychain/${HOSTNAME}-sh
	fi
fi

# finally, a calculator!!
calc () { echo "$*" | bc -l; }

# Repeat.  Useful for commands wanting to be repeated x times.
# From Advanced Bash Scripting Guide.
function repeat()
{
	local i max
	max=$1; shift;
	for ((i=1; i <= max ; i++)); do	# --> C-like syntax
		eval "$@";
	done
}

# Ask.  For if I want a script to 'ask' a question or not.
# From Advanced Bash Scripting Guide.
function ask()
{
	echo -n "$@" '[y/n] ' ; read ans
	case "$ans" in
		y*|Y*) return 0 ;;
		*) return 1 ;;
	esac
}

# Swap.  If I need to swap two files with names around.
function swap () {
        if [ $# -ne 2 ]; then
                echo "swap: 2 arguments needed"; return 1
        fi

        if [ ! -e $1 ]; then
                echo "swap: $1 does not exist"; return 1
        fi

        if [ ! -e $2 ]; then
                echo "swap: $2 does not exist"; return 1
        fi

        local TMPFILE=tmp.$$ ; mv $1 $TMPFILE ; mv $2 $1 ; mv $TMPFILE $2
}

# Upload functions, for sending files to servers.
function dndawswan () { scp "$1" whitedrake@whitedrake.awswan.com:~/whitedrake.net/dnd/ ; }
function upawswan () { scp "$1" whitedrake@whitedrake.awswan.com:~/whitedrake.net/$2 ; }
function upaquinor () { scp -P 3764 "$1" ridayah@whitedrake.homelinux.net:~/public_html/$2 ; }

# This is to get a new host ready for everything; sets up bashrc and bash_profile, sets
# up the ssh key, and then sends the scripts tar.bz2
function preparehost () {
	if [ $# -lt 2 ]; then
		echo "You have not entered enough arguments.  Proper format is preparehost <port> <host>."
	else	
		tar -czf newhost.tgz \
			.screen/default-screenrc \
			.screen/default-minscreenrc \
			.screen/temp.sh \
			.screen/traff.sh \
			.screen/uptime.sh \
			.bashrc \
			.bash_profile \
			.bash_logout \
			scripts/yasis \
			newhost-todo.txt
		scp -P $1 $HOME/newhost.tgz $2:~/newhost.tgz
		ssh -p $1 $2 "mkdir -p .ssh .screen scripts; tar -zxvf newhost.tgz; rm newhost.tgz"
		rm newhost.tgz
	fi
}

# Put our keys somewhere, this is if we don't have ssh-installkeys.
function installkeys () {
	if [ $# -lt 2 ]; then
		echo "You have not entered enough arguments.  Proper format is installkeys <port> <user@host>."
	else
		cat ~/.ssh/id_dsa.pub | ssh -p $1 $2 "cat - >> ~/.ssh/authorized_keys2"
	fi
}

# Mounting and unmounting ISO's.
function miso () { mount -t iso9660 -o ro,loop -- "$@" /media/iso; }
alias umiso="umount -- /media/iso"

# Good Songs for the music I like. :3
function goodsong () { 
	echo "$@" >> goodsongs
	echo "$@ added to the list of good songs."
}

# Find a file with a pattern in name:
function ff () { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe () { find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;  ; }

# Backup one directory level
function . () {
	if [ $1 ]; then
		source $1
	else
		cd ..
	fi
}

# Backup two directory levels
function .. () {
	cd ../..
}

# Backup three directory levels
function ... () {
	cd ../../..
}

# Backup four directory levels
function .... () {
	cd ../../../..
}

# Backup five directory levels
function ..... () {
	cd ../../../../..
}

# Shows all ansi color codes and what they look like. Mildly useful!
# Author: Nico Golde <nico(at)ngolde.de> Homepage: http://www.ngolde.de
function showansicodes () {
    for attr in 0 1 4 5 7 ; do
        echo "----------------------------------------------------------------"
        printf "ESC[%s;Foreground;Background - \n" $attr
        for fore in 30 31 32 33 34 35 36 37; do
            for back in 40 41 42 43 44 45 46 47; do
                printf '\033[%s;%s;%sm %02s;%02s  ' $attr $fore $back $fore $back
            done
        printf '\n'
        done
        printf '\033[0m'
    done
}

# From Advanced Bash Scripting Guide, a lowercase filename function! Could be useful.
function lowercase()  # move filenames to lowercase
{
	for file ; do
		filename=${file##*/}
		case "$filename" in
			*/*) dirname==${file%/*} ;;
			*) dirname=.;;
		esac
		nf=$(echo $filename | tr A-Z a-z)
		newname="${dirname}/${nf}"
		if [ "$nf" != "$filename" ]; then
			mv "$file" "$newname"
			echo "lowercase: $file --> $newname"
		else
			echo "lowercase: $file not changed."
		fi
	done
}

# From ABSG again, this is for if I want my exit to be prettyful.
#function _exit()	# function to run upon exit of shell
#{
#	echo -e "Hasta la vista, baby"
#}
#trap _exit EXIT

# If I ever got twitter, I'd like this.
# twitter client
twitter () {
	#local user='myusername';
	#local pass='mypass';
	echo -n "Enter Twitter Username: "
        read -e user
        echo -n "Enter Twitter Password: "
        read -e pass
        local twit=`echo -n "$@"`
	if [ -z "$twit" ]; then
		echo 'Enter your twit and hit return'
		read twit
	fi
	echo -n 'wait...'
	curl -u"$user:$pass" -dstatus="$twit" https://twitter.com/statuses/update.xml >/dev/null 2>&1 && echo 'okay'
}

weather ()
{ 
	echo -n "Enter Zip Code: "
	read -e zipcode
	declare -a WEATHERARRAY 
	WEATHERARRAY=( `elinks -dump "http://www.google.com/search?hl=en&lr=&client=firefox-a&rls=org.mozilla%3Aen-US%3Aofficial&q=weather+$zipcode&btnG=Search" | grep -A 5 -m 1 "Weather for" | grep -v "Add to "`) 
	echo ${WEATHERARRAY[@]} 
}


# An alias, but is big enough I'm putting it here!
# From http://www.suseblog.com/?p=331
alias sup="( id; hostname; dnsdomainname; date; uptime; uname -a; free -mot ) | awk '\
	BEGIN {FS=\"[ =]\"};\
	(NR == 1) {FS=\" \"; print \" user : \" \$2 \"\n groups : \" \$6};\
	(NR == 2) {print \" hostname : \" \$0};\
	(NR == 3) {print \" domain : \" \$0};\
	(NR == 4) {print \" date : \" \$0};\
	(NR == 5) { NF=NF; print \" uptime : \" \$0};\
	(NR == 6) {print \" kernel : \" \$0};\
	(NR == 8) {print \" RAM : \" \$2 \" Mb Total, \" \$3 \" Mb Used, \" \$4 \" Mb Free\"};\
	(NR == 9) {print \" SWAP : \" \$2 \" Mb Total, \" \$3 \" Mb Used, \" \$4 \" Mb Free\"}'"

function netinfo () {
	echo "--------------- Network Information ---------------"
	/sbin/ifconfig | awk /'inet addr/ {print $2}'
	echo ""
	/sbin/ifconfig | awk /'Bcast/ {print $3}'
	echo ""
	/sbin/ifconfig | awk /'inet addr/ {print $4}'

	# /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
	echo "---------------------------------------------------"
}

###
###   Handy Daemons Commands
###
start()
{
    for arg in $*
    do
        sudo /etc/rc.d/$arg start
    done
}
stop()
{
        for arg in $*
        do
        sudo /etc/rc.d/$arg stop
    done
}
restart()
{
        for arg in $*
        do
        sudo /etc/rc.d/$arg restart
    done
}
reload()
{
        for arg in $*
        do
        sudo /etc/rc.d/$arg reload
    done
}

# How many decimal places? (zero or positive integer)
function lsbytesum () {
	let scale=3

	# Use awk to sum the fifth field of the list of files (only):
	TotalBytes="$(ls -l | awk '/^-/ {total+=$5} ; END {print total}')"

	# if TotalBytes is empty, set it to zero:
	if [ "${TotalBytes}x" = "x" ]; then
		let TotalBytes=0
	fi

	# Count digits, then print out B, KiB, MiB, GiB, or TiB:
	case $(echo -n $TotalBytes | wc -c) in
		1 | 2 | 3) echo -n "${TotalBytes}B" ;;
		4 | 5 | 6) echo "$(echo -e "scale=${scale} \n${TotalBytes}/1024 " | bc)KiB" ;;
		7 | 8 | 9) echo "$(echo -e "scale=${scale} \n${TotalBytes}/1048576 " | bc)MiB" ;;
		10 | 11 | 12) echo "$(echo -e "scale=${scale} \n${TotalBytes}/1073741824 " | bc)GiB" ;;
		*) echo "$(echo -e "scale=${scale} \n${TotalBytes}/1099511627776 " | bc)TiB" ;;
	esac
}

function memavailable () {
	local curmem="$(free -m | grep 'buffers/cache' | awk '{print $4}')"
	local totalmem="$(free -m | grep 'Mem' | awk '{print $2}')"
	local swaptotal="$(free -m | grep 'Swap' | awk '{print $2}')"
	local swapfree="$(free -m | grep 'Swap' | awk '{print $4}')"

	# Now for calculations
	freemem="$(echo -e "scale=2 \n${curmem}*100/${totalmem} " | bc)"
	freeswap="$(echo -e "scale=2 \n${swapfree}*100/${swaptotal} " | bc)"

	# Print result.
	echo "Mem: ${freemem}%/${freeswap}%"
}


	
# Big Functions
#
# This is the functions that are a weeeeee bit larger than most of these in here;
# and therefore get their own area!
#################################################################################

#-------------------------------------------------------------
# h
# History manipulation function.  It displays the command history in reverse order.
# The number of commands displayed is set by $list_size.  After the initial listing
# a "> " prompt appears.  The user has three choices: 1) Press dot "." to exit 
# doing nothing more, 2) Press "enter" to display the next listing of commands,
# or 3) Enter the number of a command which is executed.  Since the command is
# executed from this function it isn't added to the command history.
function h () {
	local list_size=10

	# If $1 is a number then just execute it without displaying list
	if [ $1 ]; then
		local command=`fc -ln  $1 $1`
		echo $command
		local command="eval `fc -ln  $1 $1`"
		$command
		return
	fi

	# Initialize the bottom of the list
	local bottom=$HISTSIZE
	let bottom=HISTCMD-HISTSIZE
	if [ $bottom -lt 1 ];then
		bottom=1
	fi

	# Setup the start of the listing
  	local start=$HISTCMD
	let start=start-list_size
	if [ $start -lt $bottom ];then
		start=$bottom
	fi

	# Setup the end of the listing
   	local stop=$HISTCMD
	let stop=stop-1

	# Display the first listing
  	fc -lr  $start $stop

	# Get user input on what to do next
   	local response=""
	while [ "$response" = "" ]; do
		read -a response -p ". to exit | enter for more | NNN to execute> "

		# Display next listing if enter pressed
  		if [ "$response" = "" ]; then
			let stop=start-1
			if [ $stop -le $bottom ];then
				stop=$bottom
			fi
			let start=start-list_size
			if [ $start -lt $bottom ];then
				start=$bottom
			fi
			fc -lr  $start $stop
		fi
	done

	# Exit if "." pressed
	if [ "$response" = "." ]; then 
		return
	fi

	# Try to execute the line number entered by user
   	local command=`fc -ln  $response $response`
	echo $command
	local command="eval `fc -ln  $response $response`"
	$command

	# 051205 jrl - The following 4 lines used a temp file to execute the command
    	#echo "$command" >| /tmp/$$.command
	#chmod 700 /tmp/$$.command
	#/tmp/$$.command
	#rm -f /tmp/$$.command
} # h

# Extract
# This is good for extracting ANY file that is compressed.  Horray no guesswork.
function extract () {
	
	##### Probably done more robustly with file(1) but not as easily
	local FILENAME="${1}"
	local FILEEXTENSION=`echo ${1} | cut -d. -f2-`
    
	case "$FILEEXTENSION" in
		tar) tar xvf "$FILENAME";;
		tar.gz) tar xzvf "$FILENAME";;
		tgz) tar xzvf "$FILENAME";;
		gz) gunzip "$FILENAME";;
		tbz) tar xjvf "$FILENAME";;
		tbz2) tar xjvf "$FILENAME";;
		tar.bz2) tar xjvf "$FILENAME";;
		tar.bz) tar xjvf "$FILENAME";;
		bz2) bunzip2 "$FILENAME";;
		tar.Z) tar xZvf "$FILENAME";;
		Z) uncompress "$FILENAME";;
		zip) unzip "$FILENAME";;
		rar) unrar x "$FILENAME";;
	esac
}

# Show-Archive
# Still working on this one to make it as robust as above, but not urgent right now.
function show-archive () {
	if [ -f $1 ]; then
		case $1 in
			*.tar.gz)   gunzip -c $1 | tar -tf - -- ;;
			*.tar)      tar -tf $1 ;;
			*.tgz)      tar -ztf $1 ;;
			*.zip)      unzip -l $1 ;;
			*)      echo "'$1' Error. Please go away" ;;
		esac
	else
		echo "'$1' is not a valid archive"
	fi
}

# Printdir -- Useful function for printing a directory listing.
#Thanks to "Wicked Cool Shell Scripts: 101 Scripts for Linux, Mac OS X, and Unix Systems"
function printdir () {

	# given input in Kb, output in Kb, Mb or Gb for best output format
        gmk () { 
		if [ $1 -ge 1000000 ]; then
			echo "$(scriptbc -p 2 $1 / 1000000)Gb";
		elif [ $1 -ge 1000 ]; then
			echo "$(scriptbc -p 2 $1 / 1000)Mb";
		else
			echo "${1}Kb"
		fi
	}

	dir=`pwd` #save our spot

 	if [ $# -gt 1 ]; then
		echo "Usage: $0 [dirname]" >&2;
	elif [ $# -eq 1 ]; then
		cd -- "$@";
	fi

	for file in *; do
		if [ -d "$file" ]; then
			size=$(l -d "$file" | wc -l | sed 's/[^[:digit:]]//g');
			if [ $size -eq 1 ]; then
				echo "$file ($size entry)|";
			else
				echo "$file ($size entries)|";
			fi
		else
			size="$(l -dsk "$file" | awk '{print $1}')";
			echo "$file ($(gmk $size))|";
		fi
	done | \
	sed 's/ /^^^/g' | \
	xargs --max-procs=0 -n 2   | \
	sed 's/\^\^\^/ /g' | \
	awk -F\| '{ printf "%-39s %-39s\n", $1, $2 }'

	cd $dir;
}

# Scriptbc is part of above.
function scriptbc () {
  if [ $1 = "-p" ] ; then
                precision=$2
                shift 2
  else
                precision=2             # default
  fi

  bc -q -l << EOF
scale=$precision
$*
quit
EOF
}

# Dunno where this one's from, but it's been useful more than once!
# Recurse down from current directory, convert everything to png, and optimize.
# Current bugs: doesn't delete converted files.
# find . -name "*.jpg" -execdir echo {} \; | sed 's/\.[^.]*$//'
alias recurse_picture="picture_convert"
alias picture_convert="(picture_convert_to_png &)"
function picture_convert_to_png () {
	for directory in `find . -name "*.jpg" -exec dirname "{}" \; | sort | uniq`; do
		pushd .;
		cd $directory;
		fmt
		popd;
	done

	find . -name "*.jpg" -exec sh -c "convert -- {} {}.png && rm -- {} " \;;
	find . -name "*.jpeg" -exec sh -c "convert -- {} {}.png && rm -- {} " \;;
	find . -name "*.gif" -exec sh -c "convert -- {} {}.png && rm -- {} " \;;
	find . -name "*.bmp" -exec sh -c "convert -- {} {}.png && rm -- {} " \;;
	find . "*.png" -mmin -500 -exec nice optipng -o9 -- {} +;

	for file in `find . -name "*.jpg.png"`; do
		# remove everything starting with last '.'
		base=`echo "$file" | sed 's/\.[^.]*$//' | sed 's/\.[^.]*$//'`;
		mv -- $file $base.png;
	done
}

# Pretty nice pager function, but I've never used it, and don't have the heart to remove it.
# Maybe someone else will make more use of it than me! Again, dunno where found.
alias p="pager"
function pager () {
	#first, let's handle the case of stuff being piped here.
	if [ $# = 0 ] #If there are no arguments, then just run less on stdin
	then
		less --;
	else
		for argument in "$@"; #loop over arguments
		do
			length=`ls -s "$1" | cut -d " " -f 1`
			if [[ $((length > 4)) = 1 ]] #0 is false, 1 is true; the 4 is a heuristic
			then
				less "$1"; #If it is too long, then...

			else
				if [ -n `echo "$1" | grep ".bz\|.gz\|.bz2"` ]
				#we need to know whether it is compressed. less can handle compressed.
				then
					less "$1";
				else
					cat "$1"; #If it is short, than cat suffices.
				fi
			fi
			shift;
		done;
	fi
}

# I think this script is problemmatic, but again included for completeness.
#function compress () {
##!/bin/sh
##given a file or files, it compresses them using all known methods and reports the smallest one.
#  Z="zip"
#  gz="gzip"
#  bz="bzip2"
#  Zout="/tmp/bestcompress.$$.zip"
#  gzout="/tmp/bestcompress.$$.gz"
#  bzout="/tmp/bestcompress.$$.bz"
#  skipcompressed=1
#  if [ $1 = "-a" ] then
#    skipcompressed=0
#    shift
#  fi
#  if [ $# -eq 0 ] then
#    echo "Usage: $0 [-a] file or files to optimally compress" >&2;
#  fi
#  trap "/bin/rm -f -- $Zout $gzout $bzout" EXIT
#  for name
#  do
#    if [ ! -f "$name" ] ; then
#             echo "$0: file $name not found. Skipped." >&2
#                        continue
#                fi
#                if [ "$(echo $name | egrep '(\.zip$|\.gz$|\.bz2$)')" != "" ] ; then
#                        if [ $skipcompressed -eq 1 ] ; then
#                                echo "Skipped file ${name}: it's already compressed."
#                                continue
#                        else
#                                echo "Warning: Trying to double-compress $name"
#                        fi
#                fi
#                $Z < "$name" > $Zout &
#                $gz < "$name" > $gzout &
#                $bz < "$name" > $bzout &
#                wait    # run compressions in parallel for speed. Wait until all are done
#                smallest="$(ls -l "$name" $Zout $gzout $bzout | \
#   awk '{print $5"="NR}' | sort -n | cut -d= -f2 | head -1)"
#                case "$smallest" in
#                        1 ) echo "No space savings by compressing $name. Left as-is."
#                                ;;
#                        2 ) echo Best compression is with compress. File renamed ${name}.zip
#                                mv $Zout "${name}.zip" ; rm -f -- "$name"
#                                ;;
#                        3 ) echo Best compression is with gzip. File renamed ${name}.gz
#                                mv $gzout "${name}.gz" ; rm -f -- "$name"
#                                ;;
#                        4 ) echo Best compression is with bzip2. File renamed ${name}.bz2
#                                mv $bzout "${name}.bz2" ; rm -f -- "$name"
#                esac
#        done
#}

# Same as above, included for completeness but I do not like.
#Thanks to "Wicked Cool Shell Scripts: 101 Scripts for Linux, Mac OS X, and Unix Systems"
#function environment_validate () {
#!/bin/sh
# VALIDATOR - Checks to ensure that all environment variables are valid
#  looks at SHELL, HOME, PATH, EDITOR, MAIL, and PAGER
#  errors=0
#  in_path ()
#  { # given a command and the PATH, try to find the command. Returns
#   # 1 if found, 0 if not. Note that this temporarily modifies the
#   # the IFS input field seperator, but restores it upon completion.
#                cmd=$1  path=$2  retval=0
#                oldIFS=$IFS; IFS=":"
#                for directory in $path
#                do
#                        if [ -x $directory/$cmd ]
#                        then
#                                retval=1;   # if we're here, we found $cmd in $directory
#                        fi
#                done
#                IFS=$oldIFS
#                return $retval
#  }
#  validate ()
#  {
#                varname=$1  varvalue=$2
#                if [ ! -z $varvalue ]
#                then
#                        if [ "${varvalue%${varvalue#?}}" = "/" ]
#                        then
#                                if [ ! -x $varvalue ]
#                                then
#                                        echo "** $varname set to $varvalue, but I cannot find executable.";
#                                        errors=$(( $errors + 1 ));
#                                fi
#                        else
#                                if in_path $varvalue $PATH
#                                then
#                                        echo "** $varname set to $varvalue, but I cannot find it in PATH."
#                                        errors=$(( $errors + 1 ))
#                                fi
#                        fi
#                fi
#  }
#  ####### Beginning of actual shell script #######
#  if [ ! -x ${SHELL:?"Cannot proceed without SHELL being defined."} ]
#  then
#                echo "** SHELL set to $SHELL, but I cannot find that executable.";
#                errors=$(( $errors + 1 ));
#  fi
#  if [ ! -d ${HOME:?"You need to have your HOME set to your home directory"} ]
#  then
#                echo "** HOME set to $HOME, but it's not a directory."
#                errors=$(( $errors + 1 ))
#  fi
# Our first interesting test: are all the paths in PATH valid?
#  oldIFS=$IFS; IFS=":"   # IFS is the field separator. We'll change to ':'
#  for directory in $PATH
#  do
#                if [ ! -d $directory ]
#                then
#                        echo "** PATH contains invalid directory $directory";
#                        errors=$(( $errors + 1 ))
#                fi
#  done
#  IFS=$oldIFS       # restore value for rest of script
## The following can be undefined, and they can also be a progname, rather
## than a fully qualified path. Add additional variables as necessary for
## your site and user community.
#  validate "EDITOR" $EDITOR
#  validate "MAILER" $MAILER
#  validate "PAGER" $PAGER
## and, finally, a different ending depending on whether errors > 0
#  if [ $errors -gt 0 ]
#  then
#                echo "Errors encountered. Please notify sysadmin for help.";
#  else
#                echo "Your environment checks out fine.";
#  fi
#}



#################################################################################
# TODO
#
# Write a script for preparing a host.  Something that uploads bash files, a
# basic screen config file, installs ssh keys and the like, and whatever else
# I decide.  Since I rarely get new hosts this is not urgent, but definitely
# a priority.
#################################################################################

#################################################################################
# FINISHING TOUCHES
#
# I have to.  BITE ME. D:
#################################################################################

clear
echo -e "\e[;37m";echo "Welcome!";
echo -ne "\e[0;31mToday is:\t\t\e[0;36m" `date`; echo ""
echo -e "\e[0;31mKernel Information: \t\e[0;36m" `uname -smr`
echo -ne "\e[0;36m";echo -ne "\e[0;32m$HOSTNAME \e[0;31muptime is \e[0;36m \t ";uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}';echo ""
echo -e "\e[1;33m"; cal -3; echo -e "\e[1;35m" 

if [[ -x /usr/games/fortune || -x /usr/bin/fortune ]]; then
	fortune -ae;
fi
