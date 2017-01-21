#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi


export JAVA_HOME=$(/usr/libexec/java_home -v '1.8*')
export ANT_HOME=$HOME/bin/apache-ant-1.9.4
export ANDROID_HOME=$HOME/bin/android-sdk-macosx
export ANDROID_TOOLS=$ANDROID_HOME/tools
export ANDROID_PLATFORM_TOOLS=$ANDROID_HOME/platform-tools
export ANDROID_SDK=$ANDROID_HOME
export ANDROID_NDK=$ANDROID_HOME/android-ndk-r10e
export SHOUTEM_TOOLKIT=$HOME/Documents/Code/BuildSystem/ShoutEmToolkit
export PATH=$SHOUTEM_TOOLKIT:$JAVA_HOME/bin:$ANT_HOME/bin:$HOME/bin:$ANDROID_TOOLS:$ANDROID_PLATFORM_TOOLS:$PATH
export EDITOR=vim
export REACT_EDITOR=mvim

# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
# # cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
