#          _              
#  _______| |__  _ __ ___ 
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__ 
# /___|___/_| |_|_|  \___|
#                         
#

umask 022
limit coredumpsize 0
bindkey -d

# It is necessary for the setting of DOTPATH
if [[ -f ~/.path ]]; then
    source ~/.path
else
    export DOTPATH="${0:A:t}"
fi

# DOTPATH environment variable specifies the location of dotfiles.
# On Unix, the value is a colon-separated string. On Windows,
# it is not yet supported.
# DOTPATH must be set to run make init, make test and shell script library
# outside the standard dotfiles tree.
if [[ -z $DOTPATH ]]; then
    echo "$fg[red]cannot start ZSH, \$DOTPATH not set$reset_color" 1>&2
    return 1
fi

# anyenv
if [ -d $HOME/.anyenv ] ; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
    for anyenvdir in `ls $HOME/.anyenv/envs`
    do
        export PATH="$HOME/.anyenv/envs/$anyenvdir/shims:$PATH"
    done
fi

## self setting
alias gbnew="git fetch upstream; git merge upstream/develop"
alias gsh="git rev-parse --abbrev-ref @ | xargs git push origin"
alias glogall="git log --oneline --decorate --graph --branches --tags --remotes"


# Vital
# vital.sh script is most important file in this dotfiles.
# This is because it is used as installation of dotfiles chiefly and as shell
# script library vital.sh that provides most basic and important functions.
# As a matter of fact, vital.sh is a symbolic link to install, and this script
# change its behavior depending on the way to have been called.
export VITAL_PATH="$DOTPATH/etc/lib/vital.sh"
if [[ -f $VITAL_PATH ]]; then
    source "$VITAL_PATH"
fi

# Exit if called from vim
[[ -n $VIMRUNTIME ]] && return

# Check whether the vital file is loaded
if ! vitalize 2>/dev/null; then
    echo "$fg[red]cannot vitalize$reset_color" 1>&2
    return 1
fi

# tmux_automatically_attach attachs tmux session
# automatically when your are in zsh
$DOTPATH/bin/tmuxx

if [[ -n $ZPLUG_V1 ]] || [[ -n $ZPLUG_V2 ]]; then
	if [[ -n $ZPLUG_V1 ]]; then
		source ~/.zplug/zplug
		export ZPLUG_EXTERNAL="$HOME/.zsh/zplug.zsh"
	fi
	if [[ -n $ZPLUG_V2 ]]; then
		source ~/.zplug/init.zsh
		export ZPLUG_LOADFILE="$HOME/.zsh/zplug.zsh"
	fi

    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        else
            echo
        fi
    fi
    zplug load --verbose
fi

# Display Zsh version and display number
printf "\n$fg_bold[cyan]This is ZSH $fg_bold[red]${ZSH_VERSION}"
printf "$fg_bold[cyan] - DISPLAY on $fg_bold[red]$DISPLAY$reset_color\n\n"
# load docker-machine env.
eval $(docker-machine env dev)

# go
export GOPATH=~/.go

# git 

alias gsh="git b | grep '*' | cut -d'*' -f2 | xargs git push origin "
alias ga="git add -p"
alias grm="git rm $(git ls-files --deleted)"

# direnv
# export EDITOR=vim
# eval "$(direnv hook zsh)"

# vim:fdm=marker fdc=3 ft=zsh ts=4 sw=4 sts=4:
### Added by the Bluemix CLI
source /usr/local/Bluemix/bx/zsh_autocomplete
export PATH=${PATH}:/Users/kota-matsumoto/Library/Enthought/Canopy_64bit/User/bin
alias ipython='ipython --pylab'
human_show_diff() {
    FROM=${1:-staging}
    TO=${2:-master}
    TOKEN=RHcC8ArBz9Ni-bxgUt81
    PID=2
    curl -H "PRIVATE-TOKEN: ${TOKEN}" https://gitlab-hk0.apdev.jp:8888/api/v3/projects/${PID}/repository/compare\?from\=${FROM}\&to\=${TO} | jq ".commits[].message" | sed 's/.*tr(//g' | sed 's/).*//g' | sed 's/^".*"$//g' | sort |uniq | xargs -IXXXX echo "https://trello.com/c/"XXXX
}
human_dump_cards() {
    LID=${1:-56558c35b3a90e9a549ac498}
    KEY=ee1bc88f30d0ce70f488181f00ecb43c
    TOKEN=939ead66327415574d3325529a56da24f9b8bf02e1e74d905e5109b2c7d8a6f9
    curl https://api.trello.com/1/lists/${LID}/cards\?key\=${KEY}\&token\=${TOKEN} | jq ".[].name"
}

human_dump_lists() {
    LID=${1:-rlVnhAb3}
    KEY=ee1bc88f30d0ce70f488181f00ecb43c
    TOKEN=939ead66327415574d3325529a56da24f9b8bf02e1e74d905e5109b2c7d8a6f9
    curl https://api.trello.com/1/boards/${LID}/lists\?key\=${KEY}\&token\=${TOKEN} | jq ".[] | .name , .id"
}

