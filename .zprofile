export HOMEBREW_GITHUB_API_TOKEN=46ca07e8fc3a71a17bad2110868454dca104fe00
export HOMEBREW_NO_AUTO_UPDATE=1
export PATH=~/.local/bin:$PATH
export PATH=~/flutter/bin:$PATH
export PATH=~/go/bin:$PATH
export PATH=/usr/local/opt/ruby/bin:$PATH
export PATH=$HOME/.gem/ruby/2.6.0/bin:$PATH
export GOPATH=~/go

# paths for react native
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export JAVA_HOME=`/usr/libexec/java_home -v 9`

# Setting PATH for Python 3.6
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

export PATH="$HOME/.cargo/bin:$PATH"

export R_LIBS_USER="$HOME/R/lib"
export NEOVIM_JS=1
export NEOVIM_SCI=1
export NEOVIM_GO=1
export NEOVIM_PYTHON3_PATH="/usr/local/bin/python3"
export NEOVIM_PYTHON_PATH="/usr/local/bin/python2"

[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"
