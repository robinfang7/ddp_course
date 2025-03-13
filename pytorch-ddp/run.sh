#!/bin/bash
node_arr=( "$@" )
#echo "nnodes: $#, node list: $@" # $# is arguments number, $@ are arguments

NODE_ADDR=`/bin/hostname -s`
NNODES=$#
echo " ** which_node: $NODE_ADDR, nnodes: $#, node list: $@ **"

export CUDA_VISIBLE_DEVICES=0,1 #,2,3,4,5,6,7
export OMP_NUM_THREADS=1

SIF="/work/TWCC_cntr/pytorch_23.08-py3.sif"
SINGULARITY="singularity run --nv -B /work:/work $SIF"

TORCHRUN="torchrun --nproc-per-node=2 --nnodes=$# --master-addr=$1 --master-port=1234"

CMD="multigpu_torchrun.py 10 10"

for (( i=0; i<$NNODES; i++))
do
    if [ $NODE_ADDR == ${node_arr[$i]} ]; then
        echo "run: $NODE_ADDR, $SINGULARITY $TORCHRUN --node-rank $i $CMD"
        $SINGULARITY $TORCHRUN --node-rank $i $CMD
    fi
done
