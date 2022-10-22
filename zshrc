export PATH=$HOME/bin/:$HOME/.cargo/bin/:$HOME/.local/bin/:$PATH:/opt/android-studio/bin/:/opt/google/chrome/:$ANDROID_SDK/cmdline-tools/latest/bin/:$HOME/.local/share/nvim/mason/bin/:$HOME/go/bin/:/home/rit/.local/share/gem/ruby/3.0.0/bin
export ADNROID_SDK="/opt/android-sdk/"
export ZSH="$HOME/.oh-my-zsh"
export ANDROID_HOME="/opt/android-sdk/"
export no_proxy="lohost,127.0.0.1"
# export JAVA_HOME="/usr/lib/jvm/default/"
export JAVA_HOME="/usr/lib/jvm/java-18-openjdk/"

ZSH_THEME="ritz"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias so="source $HOME/.zshrc"
