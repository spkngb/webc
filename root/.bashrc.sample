## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## ~/.bashrc version 1.0.12 (2018-06-09-01)
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## === BOF ===
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=1000000000
HISTTIMEFORMAT="[ %Y-%m-%d ~ %T ] "

# save and reload history before showing prompt
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# default editor and viewer
EDITOR=vim
PAGER="less -X -R -F"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    ## -- alias ls='ls -G'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

function basename() {
    str=$1
    a=${str##*/}
    echo $a
}

function dirname() {
    str=$1
    a=${str%/*}
    echo $a
}

function realpath()
{
    f=$@

    if [ -d "$f" ]; then
        base=""
        dir="$f"
    else
        base="/$(basename "$f")"
        dir=$(dirname "$f")
    fi

    dir=$(cd "$dir" && if [ -x /bin/pwd ]; then /bin/pwd ; else pwd ; fi)

    echo "$dir$base"
}

# Set prompt path to max 2 levels for best compromise of readability and usefulness
promptpath () {
    realpwd=$(realpath $PWD)
    realhome=$(realpath $HOME)

    # if we are in the home directory
    if echo $realpwd | grep -q "^$realhome"; then
        path=$(echo $realpwd | sed "s|^$realhome|\~|")
        if [ "$path" = "~" ] || [ "$(dirname "$path")" = "~" ]; then
            echo $path
        else
            echo $(basename $(dirname "$path"))/$(basename "$path")
        fi
        return
    fi

    path_dir=$(dirname "$PWD")
    # if our parent dir is a top-level directory, don't mangle it
    if [ .$(dirname "$path_dir") = ."/" ]; then
        echo $PWD
    else
        path_parent=$(basename "$path_dir")
        path_base=$(basename "$PWD")

        echo $path_parent/$path_base
    fi
}

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

if [ "$TERM" != "dumb" ]; then
    eval "LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
        export LS_COLORS"
    if [ -x /usr/bin/dircolors ]; then
        LS_OPTS='--color=auto'
        GREP_OPTS='--color=auto'
    else
        LS_OPTS='-G'
        GREP_OPTS=''
    fi
    if [ -x /usr/bin/dircolors ]; then
        LS_OPTS=${LS_OPTS}' --time-style=long-iso'
    fi
    ## -- alias ls='ls --color=auto'
    ## -- alias ls='ls -G'
    alias ls='ls ${LS_OPTS}'
    ## -- alias ll='ls --color=auto -alF'
    ## -- alias ll='ls -G -alF'
    alias ll='ls ${LS_OPTS} -alF'
    ## -- alias la='ls --color=auto -A'
    ## -- alias la='ls -G -A'
    alias la='ls ${LS_OPTS} -A'
    ## -- alias l='ls --color=auto -CF'
    ## -- alias l='ls -G -CF'
    alias l='ls ${LS_OPTS} -CF'
    ## -- alias grep='grep --color=auto'
    alias grep='grep ${GREP_OPTS}'
    ## -- alias fgrep='fgrep --color=auto'
    alias fgrep='fgrep ${GREP_OPTS}'
    ## -- alias egrep='egrep --color=auto'
    alias egrep='egrep ${GREP_OPTS}'

    # Set a terminal prompt style (default is fancy color prompt)
    ## == PS1='${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u@\h \[\033[01;34m\]`promptpath`\[\033[00m\]\$ '
    ## == PS1='\[\033[01;33;40m\][${debian_chroot:+($debian_chroot)}\[\033[01;36;40m\]\u\[\033[01;33;40m\]@\[\033[01;32;40m\]\h\[\033[01;33;40m\]] \[\033[01;37;40m\]`promptpath`\[\033[00m\]\n\$ '

    ## == HOSTNAMELONG=`hostname --long`
    HOSTNAMELONG=`hostname -f`
    PS1='\[\033[01;33;40m\][${debian_chroot:+($debian_chroot)}\[\033[01;36;40m\]\u\[\033[01;33;40m\]@\[\033[01;32;40m\]${HOSTNAMELONG:-$HOSTNAME}\[\033[01;33;40m\]] \[\033[01;33;40m\](term=${TERM:-none}) (uid=${UID:-none}) (sty=${STY:-none}) (wnd=${WINDOW:-none}) \[\033[01;35;40m\][\D{%Y-%m-%d} \t] \[\033[01;33;40m\](\!) \[\033[01;35;40m\]: \[\033[01;37;40m\]`promptpath`\[\033[00m\]\n\$ '

    ## == echo -n "\$UID = $UID ... " ; id --user
    if ( [ "`id -u`" != "0" ]; ) then
        ## -- this is not root account
        ## == echo -n "not root and ... "
        if ( [ -z "$WINDOW" ]; ) then
            ## -- this is not window of screen
            ## == echo "not screen"
            PS1='\[\033[01;33;40m\][${debian_chroot:+($debian_chroot)}\[\033[01;36;40m\]\u\[\033[01;33;40m\]@\[\033[01;32;40m\]${HOSTNAMELONG:-$HOSTNAME}\[\033[01;33;40m\]] \[\033[01;33;40m\](term=${TERM:-none}) (uid=${UID:-none}) \[\033[01;35;40m\][\D{%Y-%m-%d} \t] \[\033[01;33;40m\](\!) \[\033[01;35;40m\]: \[\033[01;37;40m\]`promptpath`\[\033[00m\]\n\$ '
        else
            ## -- this is a window of screen
            ## == echo "screen"
            PS1='\[\033[01;33;40m\][${debian_chroot:+($debian_chroot)}\[\033[01;36;40m\]\u\[\033[01;33;40m\]@\[\033[01;32;40m\]${HOSTNAMELONG:-$HOSTNAME}\[\033[01;33;40m\]] \[\033[01;33;40m\](term=${TERM:-none}) (uid=${UID:-none}) (sty=${STY:-none}) (wnd=${WINDOW:-none}) \[\033[01;35;40m\][\D{%Y-%m-%d} \t] \[\033[01;33;40m\](\!) \[\033[01;35;40m\]: \[\033[01;37;40m\]`promptpath`\[\033[00m\]\n\$ '
        fi
    else
        ## -- this is a root account
        ## == echo -n "root and ... "
        ## == if ( [ "$TERM" != "screen" ]; ) then
        if ( [ -z "$WINDOW" ]; ) then
            ## -- this is not window of screen
            ## == echo "not screen"
            PS1='\[\033[01;33;40m\][${debian_chroot:+($debian_chroot)}\[\033[01;36;40m\]\u\[\033[01;33;40m\]@\[\033[01;32;40m\]${HOSTNAMELONG:-$HOSTNAME}\[\033[01;33;40m\]] \[\033[01;33;40m\](term=${TERM:-none}) (uid=${UID:-none}) \[\033[01;35;40m\][\D{%Y-%m-%d} \t] \[\033[01;33;40m\](\!) \[\033[01;35;40m\]: \[\033[01;37;40m\]`promptpath`\[\033[00m\]\n# '
        else
            ## -- this is a window of screen
            ## == echo "screen"
            PS1='\[\033[01;33;40m\][${debian_chroot:+($debian_chroot)}\[\033[01;36;40m\]\u\[\033[01;33;40m\]@\[\033[01;32;40m\]${HOSTNAMELONG:-$HOSTNAME}\[\033[01;33;40m\]] \[\033[01;33;40m\](term=${TERM:-none}) (uid=${UID:-none}) (sty=${STY:-none}) (wnd=${WINDOW:-none}) \[\033[01;35;40m\][\D{%Y-%m-%d} \t] \[\033[01;33;40m\](\!) \[\033[01;35;40m\]: \[\033[01;37;40m\]`promptpath`\[\033[00m\]\n# '
        fi
    fi
    ## == echo "."
else
    alias ls="ls -F"
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    PS1='${debian_chroot:+($debian_chroot)}\u@\h `promptpath`\$ '
fi

## == PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

run_scripts()
{
    for script in $1/*[^\(\.orig\)]; do
        ## == [ -x "$script" ] || continue
        echo "$(realpath $script)"
        . $script
    done
}

echo "$HOME/.bashrc.d"

run_scripts $HOME/.bashrc.d

## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## === EOF ===
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
