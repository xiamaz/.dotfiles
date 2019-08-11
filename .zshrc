# turn off the infernal correctall for filenames
unsetopt correctall

## Conda configuration
condaprofile="etc/profile.d/conda.sh"

_create_conda_env() {
	name=$1
	conda create -y -n $name python=3.7 jedi pylint flake8
	conda activate $name
	pip install neovim
}

_remove_conda_env() {
	name=$1
	if [ \( -n $CONDA_DEFAULT_ENV \) -a \( $CONDA_DEFAULT_ENV = $name \) ]; then
		conda deactivate
	fi
	conda env remove -n $name
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

source "${HOME}/.zgen/zgen.zsh"
if ! zgen saved; then
	zgen load zsh-users/zsh-syntax-highlighting
	zgen load zsh-users/zsh-history-substring-search
	zgen load zsh-users/zsh-autosuggestions

	zgen load zsh-users/zsh-completions src

	zgen load robbyrussell/oh-my-zsh
	zgen load robbyrussell/oh-my-zsh plugins/kubectl

	zgen load Tarrasch/zsh-autoenv

	# theme
	zgen load mafredri/zsh-async
	zgen load sindresorhus/pure

	zgen save
fi

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

alias cgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

replacelink() {
	if [ -L "$1" ]; then
		origin=$(readlink "$1")
		unlink $1
		cp "$origin" "$1"
	else
		echo "$1 not a symlink"
	fi
}
