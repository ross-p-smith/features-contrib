#!/bin/bash -i

set -e

source ./library_scripts.sh

echo "User: ${_REMOTE_USER}     User home: ${_REMOTE_USER_HOME}"

if [  -z "$_REMOTE_USER" ] || [ -z "$_REMOTE_USER_HOME" ]; then
  echo "***********************************************************************************"
  echo "*** Require _REMOTE_USER and _REMOTE_USER_HOME to be set (by dev container CLI) ***"
  echo "***********************************************************************************"
  exit 1
fi

USERNAME=${USERNAME:-$_REMOTE_USER}
echo "Installing Porter for user: $USERNAME"
if [ "$USERNAME" = "root" ]; then
  USER_LOCATION="/root"
else
  USER_LOCATION="/home/$USERNAME"
fi

#PORTER_HOME=${PORTER_HOME:-/usr/local/bin/porter}
export PORTER_HOME=${PORTER_HOME:-/$USER_LOCATION/.porter/}
PORTER_MIRROR=${PORTER_MIRROR:-https://cdn.porter.sh}

PORTER_VERSION=${VERSION:-latest}
PORTER_MIXINS=${MIXINS}
PORTER_PLUGINS=${PLUGINS}

# Base script taken from here
# https://cdn.porter.sh/latest/install-linux.sh

echo "Installing porter@$PORTER_VERSION to $PORTER_HOME from $PORTER_MIRROR"
echo "Mixins: ${PORTER_MIXINS}"
echo "Plugins: ${PORTER_PLUGINS}"

mkdir -p "$PORTER_HOME/runtimes"

clean_download "$PORTER_MIRROR/$PORTER_VERSION/porter-linux-amd64" "$PORTER_HOME/porter"
chmod +x "$PORTER_HOME/porter"
ln -s "$PORTER_HOME/porter" "$PORTER_HOME/runtimes/porter-runtime"
echo "Installed Porter: $($PORTER_HOME/porter version)"
echo "Users should add $PORTER_HOME to their PATH"

# Install basic Porter Mixins
"$PORTER_HOME/porter" mixin install exec --version "${PORTER_VERSION}"

# If Porter Mixins are requested, loop through and install 
if [ ${#PORTER_MIXINS[@]} -gt 0 ]; then
    echo "Installing Porter Mixins: ${PORTER_MIXINS}"
    mixins=(`echo ${PORTER_MIXINS} | tr ',' ' '`)
    for i in "${mixins[@]}"
    do
        echo "Installing ${i}"
        "${PORTER_HOME}/porter" mixin install "${i}" || continue
    done
fi

# If Porter Plugins are requested, loop through and install 
if [ ${#PORTER_PLUGINS[@]} -gt 0 ]; then
    echo "Installing Porter Plugins: ${PORTER_PLUGINS}"
    plugins=(`echo ${PORTER_PLUGINS} | tr ',' ' '`)
    for i in "${plugins[@]}"
    do
        echo "Installing ${i}"
        "${PORTER_HOME}/porter" plugin install "${i}" || continue
    done
fi

chown -R "${USERNAME}" "${PORTER_HOME}"

echo "Porter installation complete."