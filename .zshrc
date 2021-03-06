# turn off the infernal correctall for filenames
unsetopt correctall

## Conda configuration
condaprofile="etc/profile.d/conda.sh"

# Add a line if it doesn't already exist in a file
# 1 - line to be inserted
# 2 - destination file
_append_line() {
	grep -qxF "$1" $2 || echo "$1" >> $2
}

# Delete a line from a file
_delete_line() {
	sed "/^$1$/d" $2 > $2.tmp
	mv $2.tmp $2
}

_add_autoenv() {
	echo "Adding lines to .autoenv.zsh and .autoenv_leave.zsh"
	if [ ! -f ./.autoenv.zsh ]; then
		touch ./.autoenv.zsh
	fi
	if [ ! -f ./.autoenv_leave.zsh ]; then
		touch ./.autoenv_leave.zsh
	fi
	_append_line "$1" ./.autoenv.zsh
	_append_line "$2" ./.autoenv_leave.zsh
}

_del_autoenv() {
	echo "Removing lines from .autoenv.zsh and .autoenv_leave.zsh"
	_delete_line "$1" ./.autoenv.zsh
	_delete_line "$2" ./.autoenv_leave.zsh

	if [ ! -s ./.autoenv.zsh ]; then
		rm ./.autoenv.zsh
	fi
	if [ ! -s ./.autoenv_leave.zsh ]; then
		rm ./.autoenv_leave.zsh
	fi
}

_add_env_autoenv() {
	_add_autoenv "set $1=$2" "unset $1"
}

_del_env_autoenv() {
	_del_autoenv "set $1=$2" "unset $1"
}

_add_conda_autoenv() {
	_add_autoenv "pa $1" "conda deactivate"
}

_del_conda_autoenv() {
	_del_autoenv "pa $1" "conda deactivate"
}

_has_autoenv() {
	[[ ( -e .autoenv.zsh ) || ( -f .autoenv_leave.zsh ) ]]
}
autoenv() {
	case "$1" in
		show)
			if _has_autoenv; then
				echo "# .autoenv.zsh"
				cat .autoenv.zsh
				echo "# .autoenv_leave.zsh"
				cat .autoenv_leave.zsh
			else
				echo "No autoenv in current folder."
			fi
			;;
		create)
			if ! _has_autoenv; then
				echo "# commands executed on entering directory" > .autoenv.zsh
				echo "# commands executed on leaving directory" > .autoenv_leave.zsh
				autoenv edit
			else
				echo "Autoenv already exists in current directory."
			fi
			;;
		edit)
			if _has_autoenv; then
				vim .autoenv.zsh .autoenv_leave.zsh -O
			else
				echo "No autoenv in current directory."
			fi
			;;
		remove)
			rm .autoenv.zsh .autoenv_leave.zsh
			;;
		*)
			echo "ZSH autoenv management
Usage:
	show - Print autoenv in current dir.
	create - Create new autoenv in current dir if it doesn't already exist.
	edit - Edit autoenv in current directory.
	remove - Remove autoenv in current directory."
			;;
	esac
}

_create_conda_env() {
	name=$1
	conda create -y -n $name python=3.7 jedi pylint flake8 ipython
	conda activate $name
	pip install neovim
	_add_conda_autoenv "$name"
}

_remove_conda_env() {
	name=$1
	if [ \( -n $CONDA_DEFAULT_ENV \) -a \( $CONDA_DEFAULT_ENV = $name \) ]; then
		conda deactivate
	fi
	conda env remove -n $name
	_del_conda_autoenv $name
}

_export_conda_env() {
	if [ -n $CONDA_DEFAULT_ENV ]; then
		echo "Writing $CONDA_DEFAULT_ENV config to environment.yml"
		conda env export --no-builds > environment.yml
	else
		echo "Not inside env"
	fi
}

_conda_aliases() {
	alias pmk='_create_conda_env'
	alias pl='conda info --envs'
	alias pa='conda activate'
	alias pd='conda deactivate'
	alias prm='_remove_conda_env'
	alias pexport='_export_conda_env'
}

if [ -d $HOME/miniconda3 ]; then
	. $HOME/miniconda3/$condaprofile
	_conda_aliases
elif [ -d $HOME/miniconda ]; then
	. $HOME/miniconda/$condaprofile
	_conda_aliases
elif [ -d /usr/local/miniconda3 ]; then
	. /usr/local/miniconda3/etc/profile.d/conda.sh
	_conda_aliases
fi

source ~/.zinit/bin/zinit.zsh

zinit for \
    light-mode  zsh-users/zsh-autosuggestions \
    light-mode  zsh-users/zsh-history-substring-search \
    OMZP::sudo \
    OMZP::fzf \
    light-mode pick"async.zsh" src"pure.zsh" \
                sindresorhus/pure \
    pick'autoenv.zsh' nocompletions \
        Tarrasch/zsh-autoenv \
    as"completion" \
      OMZ::plugins/docker/_docker

zinit wait lucid for \
        OMZ::lib/git.zsh \
    atload"unalias grv" \
        OMZP::git

zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

# source "${HOME}/.zgen/zgen.zsh"
# if ! zgen saved; then
# 	zgen load zsh-users/zsh-syntax-highlighting
# 	zgen load zsh-users/zsh-history-substring-search
# 	zgen load zsh-users/zsh-autosuggestions
# 
# 	zgen oh-my-zsh
# 	zgen oh-my-zsh plugins/git
# 	zgen oh-my-zsh plugins/sudo
# 	zgen oh-my-zsh plugins/docker
# 	zgen oh-my-zsh plugins/docker-compose
# 
# 	zgen load zsh-users/zsh-completions src
# 
# 	zgen load Tarrasch/zsh-autoenv
# 
# 	# theme
# 	zgen load mafredri/zsh-async
# 	zgen load sindresorhus/pure
# 
# 	zgen save
# fi

# set some history options
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt share_history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

setopt extendedglob nomatch notify
unsetopt autocd beep
bindkey -e

# Speed up autocomplete, force prefix mapping
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==34=34}:${(s.:.)LS_COLORS}")';

## OS dependent settings
case "$(uname -s)" in
	Linux*)
		alias ls='ls --color'
		export PURE_PROMPT_SYMBOL=">"
		export PURE_PROMPT_VICMD_SYMBOL="<"
		export PURE_GIT_UP_ARROW="↑"
		export PURE_GIT_DOWN_ARROW="↓"
		;;
	Darwin*)
		export CLICOLOR=1
		alias mosh='LC_ALL=en_US.UTF-8 mosh'
		;;
esac

## Keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

alias cgit='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
alias ae='autoenv'
