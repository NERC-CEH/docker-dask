#!/bin/bash
# Modified from the jupyter base-notebook start.sh script
# https://github.com/jupyter/docker-stacks/blob/master/base-notebook/start.sh

set -e

# If root user
if [ $(id -u) == 0 ] ; then
  # Only the username "datalab" was created in docker build, 
  # therefore rename "datalab" to $DASK_USER
  usermod -d /home/$DASK_USER -l $DASK_USER datalab

  # Change UID of DASK_USER to DASK_UID if it does not match.
  if [ "$DASK_UID" != $(id -u $DASK_USER) ] ; then
    echo "Set user UID to: $DASK_UID"
    usermod -u $DASK_UID $DASK_USER

    # Fix permissions for home and conda directories
    for d in "$CONDA_HOME" "$DASK_USER_HOME"; do
      if [[ ! -z "$d" && -d "$d" ]]; then
        echo "Set ownership to uid $DASK_UID: $d"
        chown -R $DASK_UID "$d"
      fi
    done
  fi

  # Change GID of DASK_USER to DASK_GID, if given.
  if [ "$DASK_GID" ] ; then
    echo "Change GID to $DASK_GID"
    groupmod -g $DASK_GID -o $(id -g -n $DASK_USER)
  fi

  # Exec dask docker-entrypoint as $DASK_USER
  echo "Execute the command as $DASK_USER"
  exec su $DASK_USER -c "env PATH=$PATH $*"
else
  if [[ ! -z "$DASK_UID" && "$DASK_UID" != "$(id -u)" ]]; then
    echo 'Container must be run as root to set $DASK_UID'
  fi
  if [[ ! -z "$DASK_GID" && "$DASK_GID" != "$(id -g)" ]]; then
    echo 'Container must be run as root to set $DASK_GID'
  fi
  echo "Execute the command"
  exec $*
fi
