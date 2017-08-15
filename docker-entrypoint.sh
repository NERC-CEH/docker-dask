#!/bin/bash

ROLE="${DASK_ROLE:?Must be set to SCHEDULER or WORKER}"

if [ ${ROLE} = "SCHEDULER" ]; then
  echo "SCHEDULER Node"
  /usr/bin/prepare.sh && exec dask-scheduler
else
  echo "WORKER Node"
  echo "Set scheduler address to "\"$SCHEDULER"\""
  /usr/bin/prepare.sh && exec dask-worker $SCHEDULER
fi
