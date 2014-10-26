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

export JAVA_HOME="`/usr/libexec/java_home -v '1.7*'`"
export M2_HOME=/opt/apache-maven-2.2.1
export M2=/opt/apache-maven-2.2.1/bin
export PATH=$M2:$JAVA_HOME/bin:$PATH

