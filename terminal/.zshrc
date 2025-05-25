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
export PATH="${PATH}:/home/shaun/.local/share/gem/ruby/3.2.0/bin"

## Removes the 10k line limit for zsh history
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=9000000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY

## Cleans up home dir by "forcing" programs to respect XDG standards
## use with caution when upgrading already installed programs
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

## Enables Wayland support for certain programs
## if a Wayland session is detected
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
    export KITTY_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland # this fixes OBS specifically
fi

## Fixes an error with Xwayland acceleration (probably specific to my system)
#export EGL_PLATFORM=gbm
export EGL_PLATFORM=wayland # testing this

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
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
 COMPLETION_WAITING_DOTS="true"

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
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-fzf-history-search copyfile web-search z)

source $ZSH/oh-my-zsh.sh

# Sets the prompt to Starship
eval "$(starship init zsh)"

# Adds mangohud to $PATH, auto-enables for all Vulkan games 
#export MANGOHUD=1

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
export MANROFFOPT='-c' # fixes bug with bat & col not displaying manpages properly

# Adds common required $PATHs
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

#list
alias ls='eza -lh --group-directories-first --color=auto' # ls with human-readable enabled. doesn't show hidden files.
alias la='eza -ahl --group-directories-first --color=auto' # same as above except this shows hidden files.
alias ll='/usr/bin/ls -hla' ## No colour output. Here for compatibility and nothing else.

#turns plocate case in-sensitive
alias locate='locate -i'

#prints my first arch install birthday(not this _exact_ system install)
alias birthday='echo "September 23rd, 2021"'

## Colorize the grep & ripgrep command output for ease of use (good for log files)
alias grep='grep --color=auto'
alias rg='rg --color=auto'

#human-readable output for df
#alias df='df -h'

#removes systemd tmp filesystems in df output
alias df='df -h -x tmpfs'

#pacman unlock - don't use this unless you know what you're doing.
#alias rmpacmanlock="sudo rm /var/lib/pacman/db.lck"

#shows memory use in readable format & uses MiB.
alias free="free -mht"

# Lists all groups on the system
alias userlist="cut -d: -f1 /etc/passwd"

#merges new settings for X11
#alias merge="xrdb -merge ~/.Xresources"

#alias for software management
alias update='doas pacman -Syu'

#greps processes. identical to 'ls' except for PIDs.
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"

#grub update
alias update-grub="doas grub-mkconfig -o /boot/grub/grub.cfg"

#add new fonts/rebuild font cache.
alias update-fc='doas fc-cache -fv'

#conky causes an X11 mem leak,
#this kills conky & re-opens it
#alias kc='killall conky & sleep 1.5 && conky'

#check vulnerabilities microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

#yt-dlp instead of youtube-dl. it works far better (keeping old aliases for compat)
alias youtube-dl="yt-dlp"
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "
alias ytv-best="youtube-dl -f bestvideo+bestaudio "
alias ytdl="yt-dlp"

#Recently Installed Packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -5000 | nl"

#Displays all packages along with their disk usage
alias big="expac -H M '%m\t%n' | sort -h | nl" # shows pkg size

#Cleanup orphaned packages
alias cleanup='doas pacman -Rns $(pacman -Qtdq)'

#get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

#run dmesg as root by default
alias dmesg="doas dmesg"

#GPG related fixes, use with caution!
#verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
alias fix-gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
#receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias fix-gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
#fixes broken keyring
alias fix-key="[ -d ~/.gnupg ] || mkdir ~/.gnupg ; cp /etc/pacman.d/gnupg/gpg.conf ~/.gnupg/ ; echo 'done'"

# fixes local permissions
alias fix-permissions="doas chown -R $USER:$USER ~/.config ~/.local"

#systeminfo
alias probe="doas -E hw-probe -all -upload"

#prints system age
#alias age="stat / | awk '/Birth: /{print $2 " " substr($3,1,5)}'"
alias age='now=$(date +%s); stat -c '\''%W %Z'\'' / | awk -v now="$now" '\''{ if ($1 > 0) { age = now - $1; printf "Root directory age (since creation): %.0f days\n", age / 86400 } else { age = now - $2; printf "Root directory age (since last metadata change): %.0f days\n", age / 86400 } }'\' # better implementation


#force shutdown/reboot
alias ssn="doas shutdown now"
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

# remove git cache
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
#echo "vim: ctrl+v for visual block, shift+I, type letter, then esc and it will put it at the start of line"
#echo "vim: :%s/wordhere/newword/g to search and replace all instances of words" 
###echo "vim: :tabnew to open a new tab! :tabfirst, :tablast to switch!"
#echo "vim: 'w' to go forward a word, 'b' to go back a word, 'e' to go to the end of the word!"
#echo "vim: type ':Luapad' in vim for scratchpads! :q to close!"
echo "vim: 'daw' deletes word & space around it. 'dw' deletes word. 'dap' deletes paragraphs!"
#echo "vim: type ':vsplit ~/optional/filepath' and use ctrl+w to switch between them!"
echo "useful cmds: find, locate, whereis, type, which, file, getfacl, stat, du -s, trans, dym" | lolcat
#echo "Use 'curl getnews.tech/queryhere' to see the news!"
#echo "Use 'ctrl+super+esc' to kill windows!"
#echo "Use 'cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor' to see active governor."
#echo "Use 'iotop' to check current disk r/w speeds & usage"
#echo "Use 'trans foreign here' to translate things in the terminal!"
#echo "Use 'dym' to figure out the spelling for difficult words!"
#echo "Use 'googler' to search the web from terminal!"
#echo "Need to calculate a % value? Cat ~/Documents/How!"
#echo "Use 'vinyl' & 'vinyloff' to listen to records!"
#echo "Try 'perf top'" # a kernel topographer, h/top for kworkers essentially 
#echo "Use 'cs2' or 'csgo' to disable tear-free to reduce latency!" (X11)
#echo "Use ctrl+meta+r to open video links in MPV or Firefox!"
#echo "Tweak /etc/environment to change env variables globally!"
#echo "Use ~/.config/environment.d/envvars.conf to set them locally only!"
#echo "Use 'pipx' to install python packages!"
#echo "Use 'steamapps' to cd into steam!"
#echo "99x34 cols in kitty!"
#echo "Install 'sherlock-git' to search a username across the internet!"
####echo "Use 'icat filename' to display images natively in kitty!"
#echo "Change makepkg.conf 'PKGEXT' back to .pkg.tar.zst if lz4 causes isuses!"
#echo "Use 'watch' as a way to periodically update graph programs such as top! (use tldr)"
########echo "Use 'binsider programname' to analyze binaries!"
#echo "Use 'ls -R' to easily search dirs recursively without having to cd!"
#echo "zswap is disabled! use 'grep -r . /sys/module/zswap/parameters/' to check stats!"
##echo "Use 'lsmod' to list kernel modules!"
#echo "Remember to use '-i' with grep! It's case sensitive!"
####echo "Remember to use trash! and don't forget aliases, tlist, trestore, tempty!"
###echo "Slothrop is at an asylum, he had a map of all his sexual encounters! He's being investigated for\nthis because V-2 rockets land at these locations!"
#echo "Use 'ctrl + e' to auto-fill zsh-suggestions instead of arrow keys!"
#echo "Use ripgrep - 'rg' instead of grep! it's faster!"
echo "Use 'copyfile filename' to copy files to clipboard from terminal!"
#echo "Type 'z' & press tab to jump between recent dirs or type a dir! (e.g. z steam)" | lolcat
#echo "dmwiki is fixed! remember to use it! the wiki is fantastic."
##echo "Use 'ddcutil -d 1 getvcp ALL' to see displays' hours used!"
##echo "Changed ulimit to unlimited in '/etc/security/limits.conf!"
##echo "Added k10temp as service to '/etc/systemd/system! check if it runs!"
#####echo "Changed Dolphin so that it can open archives now! Change back if you don't like it!"
####echo "Added flags to Spotify enable Wayland! '~/.var/app/com.spotify.Client/config/spotify-flags.conf'!" # doesn't work now
#####echo "Changed coredump variables in /etc/systemd/coredump.conf.d/override.conf!"
echo "Use 'cleanupcores/coredumpcleanup' to delete coredumps one by one!"
###echo "changed root perms to 750 for /root"
#####echo "added 'kernel.core_pattern=|/bin/false' to /etc/sysctl.d/sysctl.conf to disable coredumps!"
echo "Use 'pacman -Rnc' to remove config files!"
#####echo "Added '/etc/profile.d/mesa-env.sh' to try fixing HW accel (EGL)!"
####echo "Uncomment EGL_PLATFORM in .zshrc if display issues occur!"
####echo "Re-install egl-wayland if display issues occur!"
echo "I set ollama kv cache to q8_0 in /etc/environment!"

## Useful aliases
alias sudo="doas"
alias pacman="doas pacman"
alias cp="cpg -iv -g" #requires advcpmv, adds a progress bar. change cpg to cp & remove -g otherwise
alias rm="rm -iv"
alias mv="mvg -iv -g" #requires advcpmv, adds a progress bar. change mvg to mv & remove -g otherwise
alias matrix="cxxmatrix" 
alias fish="asciiquarium"
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
alias radeontop="amdgpu_top"
alias iotop="doas iotop"
alias killall="killall -v"
alias cat="bat -Pn"
alias checkup="checkupdates"
alias googler="googler --colorize=auto"
alias vinyl="pactl load-module module-loopback"
alias vinyloff="pactl unload-module module-loopback"
alias csgo="xrandr --output DisplayPort-0 --set TearFree off" # gets rid of latency (X11)
alias cs2="xrandr --output DisplayPort-0 --set TearFree off"  # X11 only
alias tearfree="xrandr --output DisplayPort-0 --set TearFree on" # X11 only
alias themes="kitten themes"
alias balooctl="balooctl6"
alias ncdu="ncdu --color dark"
alias steamapps="/home/shaun/.steam/steam/steamapps/common/"
alias ffetch="fastfetch"
alias fetch="fastfetch"
alias icat="kitten icat"
alias ofetch="onefetch"
alias ssh="kitten ssh " #change back to kitty +kitten ssh if this doesn't work
#alias openwebui="doas docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name open-webui --restart always ghcr.io/open-webui/open-webui:main" #installs open-webui, using localhost to ensure ollama connectivity 
alias openwebui="docker start open-webui" # starts open-webui via docker

## Alias relating specifically to the 'trash-cli' package
alias trash="trash -v"
alias tlist="trash-list"
alias trestore="trash-restore"
alias tempty="trash-empty"

## Refresh pacman mirrorlist using HTTPS only, scoring 100 servers and choosing the best based on ping.
alias mirrors="reflector --score 100 --protocol https --fastest 10 --number 10 --verbose --save /etc/pacman.d/mirrorlist"

## Enables fzf, helps more easily look through shell history. ctrl + r
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Added by ProtonUp-Qt on 07-05-2025 16:52:58
if [ -d "/home/shaun/stl/prefix" ]; then export PATH="$PATH:/home/shaun/stl/prefix"; fi
