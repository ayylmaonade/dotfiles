# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
##installation via script from github
#export ZSH="/home/$USER/.oh-my-zsh"
##installation via paru -S oh-my-zsh-git
export ZSH=/home/shaun/.oh-my-zsh/

# Set $PATH for rust CLI support
export PATH="${PATH}:/home/shaun/.cargo/bin"

# Set $PATH for ruby/gem support
export PATH="${PATH}:/home/shaun/.local/share/gem/ruby/3.0.0/bin"

## Removes the 10k line limit for zsh history
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=9000000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# if you installed the package oh-my-zsh-powerline-theme-git then you type here "powerline" as zsh theme
#ZSH_THEME="duellj"
#ZSH_THEME="half-life"

# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.

# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# ZSH_THEME_RANDOM_IGNORED=(pygmalion tjkirch_mod)

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-fpdate checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
 DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=14

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-fzf-history-search)

source $ZSH/oh-my-zsh.sh

# Sets the prompt to Starship
eval "$(starship init zsh)"

# Adds mangohud to $PATH, prevents pointless .profile file in ~/
export MANGOHUD=1

# export MANPATH="/usr/local/man:$MANPATH"

# PREFERRED EDITOR FOR LOCAL AND REMOTE SESSIONS
if [[ -N $SSH_CONNECTION ]]; then 
  export EDITOR='nvim'
else
  export EDITOR='/usr/bin/vi'
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

setopt GLOB_DOTS

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export HISTCONTROL=ignoreboth:erasedups

# Make neovim the default editor
export EDITOR='nvim'
export VISUAL='nvim'

# Make 'bat' the default manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

#PS1='[\u@\h \W]\$ '

if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

#list
alias ls='exa -lh --group-directories-first --color=auto' # ls with human-readable enabled. doesn't show hidden files.
alias la='exa -ahl --group-directories-first --color=auto' # same as above except this shows hidden files.
alias ll='/usr/bin/ls -hla' ## No colour output. Here for compatibility and nothing else.

## Colorize the grep command output for ease of use (good for log files)
alias grep='grep -i --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

#readable output for df
alias df='df -h'

#pacman unlock - don't use this unless you know what you're doing.
#alias unlock="sudo rm /var/lib/pacman/db.lck"
#alias rmpacmanlock="sudo rm /var/lib/pacman/db.lck"

#shows memory use in readable format & uses MiB.
alias free="free -mht"

# Lists all groups on the system
alias userlist="cut -d: -f1 /etc/passwd"

#merges new settings for X11
alias merge="xrdb -merge ~/.Xresources"

#alias for software management
alias update='doas pacman -Syu'

#greps processes. identical to 'ls' except for PIDs.
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"

#grub update
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

#add new fonts/rebuild font cache.
alias update-fc='doas fc-cache -fv'

#quickly kill conkies
alias kc='killall conky'

#check vulnerabilities microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

#yt-dlp instead of youtube-dl. it works far better (keeping old aliases for compat)
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "
alias ytv-best="youtube-dl -f bestvideo+bestaudio "
#USE THIS!
alias ytdl="yt-dlp"

#Recently Installed Packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -5000 | nl"

#Cleanup orphaned packages
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

#get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

#gpg
#verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
alias fix-gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
#receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias fix-gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
#fixes broken keyring
alias fix-key="[ -d ~/.gnupg ] || mkdir ~/.gnupg ; cp /etc/pacman.d/gnupg/gpg.conf ~/.gnupg/ ; echo 'done'"

#fixes
alias fix-permissions="sudo chown -R $USER:$USER ~/.config ~/.local"

#maintenance
alias big="expac -H M '%m\t%n' | sort -h | nl"

#systeminfo
alias probe="sudo -E hw-probe -all -upload"

#force shutdown/reboot
alias ssn="sudo shutdown now"
alias sr="doas reboot"

#give the list of all installed desktops - xsessions desktops
alias xd="ls /usr/share/xsessions"

# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#remove
alias rmgitcache="rm -r ~/.cache/git"

## Terminal startup exec
#neofetch
pfetch
please
#colorscript exec pacman
#colorscript exec tiefighter1row
#colorscript exec crunch
#fortune

## Startup Echoes
#echo "use 'ex' to extract any compressed file/folder!"
###echo "vim: ctrl+v for visual block, shift+I, type letter, then esc and it will put it at the start of line"
echo "vim: :%s/wordhere/newword/g to search and replace all instances of words" 
##echo "vim: 'w' to go forward a word, 'b' to go back a word, 'e' to go to the end of the word!"
####echo "vim: type ':Luapad' in vim for scratchpads! :q to close!"
#echo "vim: 'daw' deletes word & space around it. 'dw' deletes word. 'dap' deletes paragraphs!"
##echo "vim: type ':vsplit ~/optional/filepath' and use ctrl+w to switch between them!"
echo "useful cmds: find, locate, whereis, which, file, getfacl, stat, du -s" | lolcat
#echo "Use 'curl getnews.tech/queryhere' to see the news!"
#echo "Use 'ctrl+super+esc' to kill windows!"
#echo "Use 'cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor' to see active governor."
#echo "Pipe 'yes' into commands like 'topgrade' to automatically accept Y/n prompts!"
###echo "Use 'downgrade' to interactively downgrade pkgs to older versions!"
#######echo "Use 'iotop' to check current disk r/w speeds & usage"
###echo "Hold super & press any of the arrow keys to snap the currently active window!"
####echo "Conky has a memory leak causing Xorg to use excessive RAM, just kill it to fix!"
##echo "Use 'trans foreign here' to translate things in the terminal!"
echo "Use 'dym' to figure out the spelling for difficult words!"
echo "Use 'ncdu' to check disk usage w/ an in-terminal ncurses interface!"
##echo "Change 'vm.max_map_count' /etc/sysctl.d/conf_file back to '65530' if issues occur!"
##echo "Use 'doas nvim' instead of 'doas vim' to prevent errors!"
echo "Remove ROCm pkgs if you find no use for them!"

## Useful aliases
alias sudo="doas"
alias pacman="doas pacman"
alias cp="cpg -iv -g" #requires advcpmv, adds a progress bar. change cpg to cp & remove -g otherwise
alias rm="rm -i"
alias mv="mvg -i -g" #requires advcpmv, adds a progress bar. change mvg to mv & remove -g otherwise
alias matrix="cxxmatrix" 
alias fish="asciiquarium"
alias starwars="nc towel.blinkenlights.nl"
alias snipebot="python3 ~/dotfiles/scripts/snipe.py" 
alias mpv="mpv --profile=swag "
alias vim="nvim" # lol
alias vi="vim" # fuck you, brian.
alias btop="bpytop" # better version of top/htop
alias gpu="echo this does nothing, dumbass"
alias lynx="lynx -vikeys -force_secure -scrollbar -show_cursor -use_mouse "
alias systemctl="doas systemctl "
alias yay="yay --sudoloop "
alias uptime="uptime -p"
alias su="doas su"
alias du="du -h"
alias rtop="radeontop" 
alias iotop="doas iotop"
alias killall="killall -v"
alias cat="bat -Pn"


## Refresh pacman mirrorlist using HTTPS only, scoring 100 servers and choosing the best based on ping.
alias mirrors="reflector --score 100 --protocol https --fastest 10 --number 10 --verbose --save /etc/pacman.d/mirrorlist"

## Enables fzf, helps more easily look through shell history. ctrl + r
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
