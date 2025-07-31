#!/bin/bash
RUN="$SINGULARITY $LAUNCHER --node_rank ${SLURM_NODEID} $CMD"
echo "$RUN"; $RUN  
