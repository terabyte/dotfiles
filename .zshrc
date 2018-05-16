# Path to your oh-my-zsh installation.
  export ZSH=/home/cmyers/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel9k/powerlevel9k"

# theme customization:
export TERM="xterm-256color"
# no custom fonts
POWERLEVEL9K_MODE="compatible"
# defaults:
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)
#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time)
# mine:
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(time battery context rbenv virtualenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history dir)
POWERLEVEL9K_BATTERY_LOW_THRESHOLD=25

# Uncomment the following line to use case-sensitive completion.
 CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
 DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker encode64 gem gradle httpie mercurial mvn node perl pip pylint repo screen sudo supervisor svn-fast-info vi-mode)

# User configuration

  #export PATH="/home/cmyers/jvms/jdk1.8.0_60/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/cmyers/bin:/home/cmyers/usr/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/X11R6/bin:/usr/X11/bin:.:/home/cmyers/.rvm/bin:/home/cmyers/bin:/home/cmyers/usr/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/X11R6/bin:/usr/X11/bin:.:/home/cmyers/.rvm/bin"
export PATH="$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/X11R6/bin:/usr/X11/bin"
# export MANPATH="/usr/local/man:$MANPATH"
export PATH="$PATH:/home/cmyers/projects/private_notes/bin"

source $ZSH/oh-my-zsh.sh

# settings "rescued" from my old zsh
setopt NO_HUP # Don't murder things in the face
# VI editing mode is a pain to use if you have to wait for <ESC> to register.
# This times out multi-char key combos as fast as possible. (1/100th of a
# second.)
export KEYTIMEOUT=1

export EXTENDED_HISTORY=1       # store time in history
export HIST_SAVE_NO_DUPS=1      # no duplicates
export HIST_EXPIRE_DUPS_FIRST=1 # unique events are more usefull to me
export HIST_IGNORE_DUPS=1       # don't insert immediately duplicated lines twice
export HIST_VERIFY=1	        # Make those history commands nice
export INC_APPEND_HISTORY=1     # immediatly insert history into history file
export SHARE_HISTORY=1          # share history between all shells...don't know if this is a good idea or not
setopt TRANSIENT_RPROMPT      # RPROMPT disappears in terminal history
export HISTFILE=$HOME/.histfile
export HISTSIZE=100000000
export SAVEHIST=100000000

# Prompt Options
export MAILCHECK=0
export REPORTTIME=5            # this is cool - any command that takes over 5 seconds will report stats

export OVERRIDE_EDITOR="vim"
export EDITOR="vim"   # programs will use this by default if you need to edit something
export PAGER=less   # less is more :)

export GIT_PAGER= # no pager for git
export LESS='-Ri'                # case insensitive searching in less and support colors
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.tex=01;33:*.sxw=01;33:*.sxc=01;33:*.lyx=01;33:*.pdf=0;35:*.ps=00;36:*.asm=1;33:*.S=0;33:*.s=0;33:*.h=0;31:*.c=0;35:*.cxx=0;35:*.cc=0;35:*.C=0;35:*.o=1;30:*.am=1;33:*.py=0;34:'
export GREP_COLOR='1;35'
export LANG=en_US.UTF-8

####
## SSH AGENT STUFF
####
# method 1
SSHAGENT="/usr/bin/ssh-agent"

# method 2
SSH_ENV="$HOME/.ssh/environment"
function start_agent {
     echo "Initialising new SSH agent..."
     $SSHAGENT | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    echo "Using existing ssh-agent"
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
}
else
    echo "Creating new ssh-agent"
    start_agent;
fi

# ALIASES

alias grep='nocorrect grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -lsarth --color=auto'
alias 'vom=vim'
alias 'psl=ps auxwwwwgf' # I die without this.
alias 'screen=screen -x -RR' # i use tmux now, but why not?
#alias 'new-firefox=MOZ_NO_REMOTE= firefox' # start a new firefox process # works?

# helpful stuff for working with perforce - kept for archeological reasons.
#alias 'pr=p4'
#alias 'p4missing=find . -type f | xargs p4 files 2>&1 | perl -ne "/(\\S+) - no such file/ && print qq(\$1\\n)"'

# Obvious.  Awesome.
alias 'u=cd ..'
alias 'uu=cd ../..'
alias 'uuu=cd ../../..'
alias 'uuuu=cd ../../../..'
alias 'uuuuu=cd ../../../../..'
alias 'uuuuuu=cd ../../../../../..'
alias 'uuuuuuu=cd ../../../../../../..'
alias 'uuuuuuuu=cd ../../../../../../../..'
alias 'uuuuuuuuu=cd ../../../../../../../../..'
alias 'uuuuuuuuuu=cd ../../../../../../../../../..'
alias 'uuuuuuuuuuu=cd ../../../../../../../../../../..'
alias 'uuuuuuuuuuuu=cd ../../../../../../../../../../../..'
alias 'uuuuuuuuuuuuu=cd ../../../../../../../../../../../../..'
alias 'uuuuuuuuuuuuuu=cd ../../../../../../../../../../../../../..'
alias 'uuuuuuuuuuuuuuu=cd ../../../../../../../../../../../../../../..'

bindkey '[1~' beginning-of-line
bindkey '[4~' end-of-line
bindkey '[3~' delete-char
bindkey '[2~' overwrite-mode

# Show the path from a symlink to its ultimate source.
# TODO: Re-examine this - isn't there a better way?
function realzpath() {
    if [[ -e $1 || -h $1 ]]; then
        file=$1
    else
        file=`which $1`
    fi
    if [[ -e $file || -L $file ]]; then
        if [[ -L $file ]]; then
# this line prints out the last modified date, I think.
#            echo `ls -ld $file | perl -ane 'print $F[7]'` '->'
            realzpath `perl -le '$file = $ARGV[0];
                              $dest = readlink $file;
                              if ($dest !~ m{^/}) {
                                  $file =~ s{(/?)[^/]*$}{$1$dest};
                              } else {
                                  $file = $dest;
                              }
                              $file =~ s{/{2,}}{/}g;
                              while ($file =~ s{[^/]+/\.\./}{}) {
                                  ;
                              }
                              $file =~ s{^(/\.\.)+}{};
                              print $file' $file`

        else
            ls -d $file
        fi
    else
        echo $file
    fi
}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
# load rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

if [[ -e ~/.java10rc ]]; then
	source ~/.java10rc
fi

bindkey -v # VI keybindings!

#AWESOME...
#pushes current command on command stack and gives blank line, after that line
#runs command stack is popped
bindkey ''    push-line-or-edit
#bindkey ''    accept-line-and-down-history
#bindkey ''    accept-and-infer-next-history
bindkey ""    history-incremental-search-backward
bindkey ""    end-of-line
bindkey ""    beginning-of-line
bindkey ''    edit-command-line

## TODO: needed?
#if [[ "$TERM" == "screen" ]]; then
#    bindkey 'OH' beginning-of-line
#    bindkey 'OF' end-of-line
#    bindkey '[3~' delete-char
#fi

export GCC_4_X_BIN="/usr/bin/g++-4.8"
export PYTHON_2_7_BIN="/usr/bin/python"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export PYTHONSTARTUP=~/.pythonrc

# FZF is amazeballs
if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
    export FZF_TMUX=1
    export FZF_TMUX_HEIGHT="20%"
    export FZF_DEFAULT_OPTS='--height 20% --min-height=10 --reverse --border --inline-info'

fi


# go to a path relative to the top directory
# of the current git worktree.
# from: https://dmerej.info/blog/post/fzf-for-the-win/
function gcd() {
    topdir=$(git rev-parse --show-toplevel)
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    cd "${topdir}/${1}"
}

if [[ -f ~/.jenkins-api-token ]]; then
    source ~/.jenkins-api-token
fi
