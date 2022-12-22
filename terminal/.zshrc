# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
#installation via script from github
#export ZSH="/home/$USER/.oh-my-zsh"
#installation via paru -S oh-my-zsh-git
export ZSH=/usr/share/oh-my-zsh/
source /usr/share/zinit/zinit.zsh
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search
plugins=(... zsh-fzf-history-search)

# Set $PATH for rust CLI support
export PATH="${PATH}:/home/shaun/.cargo/bin"

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
# DISABLE_UPDATE_PROMPT="true"

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
plugins=(git)

source $ZSH/oh-my-zsh.sh

plugins=(
	# additional plugins
	zsh-autosuggestions
)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# Sets the prompt to Starship
eval "$(starship init zsh)"

# Adds mangohud to $PATH, prevents pointless .profile file in ~/
export MANGOHUD=1

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# PREFERRED EDITOR FOR LOCAL AND REMOTE SESSIONS
if [[ -N $SSH_CONNECTION ]]; then 
  export EDITOR='nvim'
else
  export EDITOR='/usr/bin/vi'
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

####   CUSTOM SETTINGS   ####

setopt GLOB_DOTS

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export HISTCONTROL=ignoreboth:erasedups

# Make neovim the default editor
export EDITOR='nvim'
export VISUAL='nvim'

#PS1='[\u@\h \W]\$ '

if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

#list
alias ls='exa -lh --color=auto' # ls with human-readable enabled. doesn't show hidden files.
alias la='exa -ahl --color=auto' # same as above except this shows hidden files.
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

#arcolinux logout unlock
alias rmlogoutlock="sudo rm /tmp/arcologout.lock"

#shows memory use in readable format & uses MiB.
alias free="free -mht"

# Lists all groups on the system
alias userlist="cut -d: -f1 /etc/passwd"

#merges new settings for X11
alias merge="xrdb -merge ~/.Xresources"

#alias for software managment
alias update='doas pacman -Syyu'

#greps processes. identical to 'ls' except for PIDs.
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"

#grub update
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

#add new fonts/rebuild font cache.
alias update-fc='doas fc-cache -fv'

#copy/paste all content of /etc/skel over to home folder - backup of config created - beware
#alias skel='cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S) && cp -rf /etc/skel/* ~'
#backup contents of /etc/skel to hidden backup folder in home/user
#alias bupskel='cp -Rf /etc/skel ~/.skel-backup-$(date +%Y.%m.%d-%H.%M.%S)'

#copy bashrc-latest over on bashrc - cb= copy bashrc
#alias cb='sudo cp /etc/skel/.bashrc ~/.bashrc && source ~/.bashrc'
#copy /etc/skel/.zshrc over on ~/.zshrc - cb= copy zshrc
#alias cz='sudo cp /etc/skel/.zshrc ~/.zshrc && exec zsh'

#switch between bash and zsh
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"

#quickly kill conkies
alias kc='killall conky'

#hardware info --short
alias hw="hwinfo --short"

#check vulnerabilities microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

#youtube-dl
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "
alias ytv-best="youtube-dl -f bestvideo+bestaudio "
alias ytdl="youtube-dl "

#Recently Installed Packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -5000 | nl"

#iso and version used to install Linux
alias iso="cat /etc/dev-rel | awk -F '=' '/ISO/ {print $2}'"

#Cleanup orphaned packages
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

#search content with ripgrep
alias rg="rg --sort path"

#get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

#important system config files. don't touch unless you know
#what you're doing with them.
alias npacman="sudo $EDITOR /etc/pacman.conf"
alias ngrub="sudo $EDITOR /etc/default/grub"
alias nconfgrub="sudo $EDITOR /boot/grub/grub.cfg"
alias nmkinitcpio="sudo $EDITOR /etc/mkinitcpio.conf"
alias nmirrorlist="sudo $EDITOR /etc/pacman.d/mirrorlist"
alias nsddm="sudo $EDITOR /etc/sddm.conf"
alias nfstab="sudo $EDITOR /etc/fstab"
alias nnsswitch="sudo $EDITOR /etc/nsswitch.conf"
alias nsamba="sudo $EDITOR /etc/samba/smb.conf"
alias nb="$EDITOR ~/.bashrc"
alias nz="$EDITOR ~/.zshrc"

#gpg
#verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
alias fix-gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
#receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias fix-gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias fix-key="[ -d ~/.gnupg ] || mkdir ~/.gnupg ; cp /etc/pacman.d/gnupg/gpg.conf ~/.gnupg/ ; echo 'done'"

#fixes
alias fix-permissions="sudo chown -R $USER:$USER ~/.config ~/.local"
alias keyfix="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"

#maintenance
alias big="expac -H M '%m\t%n' | sort -h | nl"
alias downgrade="sudo downgrade --ala-url https://bike.seedhost.eu/arcolinux/"

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

#cool, albeit pointless graphical art & quote generator
alias atm="arcolinux-tellme"

#remove
alias rmgitcache="rm -r ~/.cache/git"

#moving your personal files and folders from /personal to ~
#alias personal='cp -Rf /personal/* ~'

#create a file called .zshrc-personal and put all your personal aliases
#in there. They will not be overwritten by skel.



## Terminal startup exec
#neofetch
#ufetch
pfetch
#colorscript exec pacman
#colorscript exec tiefighter1row
colorscript exec crunch
#fortune
xset m 3/2 0

## Startup Echoes
#echo "use doas instead of sudo!"
#echo "pacman -Ss to search!"
#echo "ctrl + a goes to the beginning of a line!"
echo "pacman -Rns to remove pkgs, its dependencies & cfg files!"
##echo "pacman -Rs to remove file & all dependencies!"
#echo "use 'w3m' to view images in the terminal!"
#echo "use 'sudoedit' instead of sudo/doas vim!"
#echo "use 'ex' to extract any compressed file/folder!"
echo "vim: ctrl+v for visual block, shift+I, type letter, then esc and it will put it at the start of line"
echo "vim: :%s/wordhere/newword/g to search and replace all instances of words" 
echo "vim: 'w' to go forward a word, 'b' to go back a word, 'e' to go to the end of the word!"
#echo "use the -S flag to sign git commits! 'git commit -S -m "msg"' "
##echo "use ctrl + F2 to switch between virtual desktops!" 
#echo "aura is no longer installed! use yay instead!"
#echo "use 'zenity' in scripts to use gui dialogs!"
##echo "use 'yay -Ps' to see all installed pkgs, including aur!"
echo "vim: type ':Luapad' in vim for scratchpads! :q to close!"
#echo "about:config: change 'layers.force-active' to false if firefox gets weird!"
#echo "vim: press 'zz' to center the line/cursor!"
echo "vim: 'daw' deletes word & space around it. 'dw' deletes word. 'dap' deletes paragraphs!"
echo "vim: type ':vsplit ~/optional/filepath' and use ctrl+w to switch between them!"
echo "useful cmds: find, locate, whereis, which, file, getfacl" | lolcat
##echo "Develop rfetch/rustfetch!" # Use neofetch & freshfetch src as help! -- /usr/bin/neofetch"
#echo "RE-WRITE 'GOL' AKA GAME OF LIFE -- GOOD PROJECT TO STREAM FOR LAUREN"
#echo "Start a project to automatically setup my Linux cfgs, a la DTOS"
##echo "Use 'dmwiki' to search the Arch Wiki offline!"
##echo "Use 'cheat' & 'tldr' to see command info!"
#echo "Use 'shellcheck' to verify shell scripts!"
#echo "Re-enable webrender settings. Picture in ~/Documents!"
#echo "Use 'curl getnews.tech/queryhere' to see the news!"
#echo "Use 'sensors' to check all hardware temps!" 
#echo "change 'media.rdd-process.enabled' to false if firefox breaks!"
echo "Use 'shift+alt+esc' to kill windows!"
##echo "Use 'super+w' to switch between windows! Fuck alt tab!"
#echo "Change all fonts down 1pt when _not_ using wayland!"
##echo "Reset 'ulimit' to default if core dumps still appear!"
##echo "Remove xset 3/2 from crontab if it doesn't work!"
##echo "Remove '*hard core 0' & comment out '*soft core* in /etc/security/limits.conf if cores still dump!" //Seems to work. Leaving for now.
##echo "Use 'cat /proc/sys/vm/swappiness' to see if it outputs '10'"
##echo "Remove '/etc/sysctl.d/99-swappiness.conf' to change swappiness back!"
#echo "Use 'WebFlix' to watch any streaming service! ~/.config/Qtwebflix"
#echo "Check ~/Desktop/pkgs.txt if anything goes wonky!"
#echo "Re-install nerd-fonts-config if things go wrong! Check desktop!"
#echo "SSD trim is enabled! 'systemctl status fstrim.timer' -- check!"
echo "Use 'feh' instead of 'w3m' to view images in terminal!"
#echo "Change '/etc/os-release' back to arcolinux if things fuck up!"
#echo "Remove 'export XDG_SESSION_TYPE' in '.xinitrc' if things fuck up!"
#echo "Re-install 'xdg-desktop-portal-gtk' if you use flatpaks!"
#echo "Push 3.5mm jack further into oDAC, it fixes headphone audio!"
#echo "Change 'terminal=' to the opposite value in autostart/mouseaccel if it doesn't work!"
##echo "Uninstall 'amf-amdgpu-pro' if encoding/decoding breaks!"
#echo "Re-install the 'amdvlk' & 'lib32-amdvlk' pkgs if testing doesn't work!"
#echo "Change 'media.hardware-video-decoding.force-enabled' to false if issues in FF occur!"
echo "Use 'rename' instead of 'mv' to change file names!"
#echo "Re-install electron17 if discord/electron apps break!"

## Useful aliases
alias love="figlet I love you lauren"
alias btop="bashtop"
alias pacman="doas pacman"
alias cp="cpg -iv -g" #requires advcpmv, adds a progress bar. change cpg to cp & remove -g otherwise
alias rm="rm -i"
alias mv="mvg -i -g" #requires advcpmv, adds a progress bar. change mvg to mv & remove -g otherwise
alias matrix="cxxmatrix" | alias cmatrix="cxxmatrix"
alias fish="asciiquarium"
alias starwars="telnet towel.blinkenlights.nl"
alias snipebot="python3 ~/dotfiles/scripts/snipe.py" #go to the directory and run ./snipe.py instead
alias mpv="mpv --profile=swag "
alias vim="nvim" # lol
alias vi="vim" # fuck you, brian.
alias btop="bpytop" # better version of top/htop
alias gpu="echo this does nothing, dumbass"
alias lynx="lynx -vikeys -force_secure -scrollbar -show_cursor -use_mouse "
alias systemctl="doas systemctl "
alias yay="yay --sudoloop "

## Refresh pacman mirrorlist using HTTPS only, scoring 100 servers and choosing the best based on ping.
alias mirrors="reflector --score 100 --protocol https --fastest 10 --number 10 --verbose --save /etc/pacman.d/mirrorlist"

## Enables fzf, helps more easily look through shell history. ctrl + r
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /home/shaun/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
