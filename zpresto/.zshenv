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


export JAVA_HOME=$(dirname $(dirname $(readlink -f /usr/bin/java)))
export M2_HOME=/opt/apache-maven-2.2.1
export M2=/opt/apache-maven-2.2.1/bin
export PATH=$M2:$JAVA_HOME/bin:$PATH
export ORACLE_HOME="/usr/lib/oracle/11.2/client64"
export LD_LIBRARY_PATH="${ORACLE_HOME}/lib"
export TNS_ADMIN="${ORACLE_HOME}"
export EDITOR=vim
export BROWSER=google-chrome
