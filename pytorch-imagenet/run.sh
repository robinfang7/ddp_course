#!/bin/bash
RUN="$SINGULARITY $CMD --rank ${SLURM_NODEID}"
echo "$RUN"; $RUN
