#!/bin/bash
node_arr=( "$@" )
echo "nnodes: $#, node list: $@" # $# is arguments number, $@ are arguments

NODE_ADDR=`/bin/hostname -s`
NNODES=$#
echo " ** which_node: $NODE_ADDR, nnodes: $#, node list: $@ **"

export CUDA_VISIBLE_DEVICES=0,1 #,2,3,4,5,6,7
export OMP_NUM_THREADS=1

SIF="/work/TWCC_cntr/pytorch_23.08-py3.sif"
SINGULARITY="singularity run --nv -B /work:/work $SIF"

CMD="python main.py \
-a resnet50 \
--batch-size 128 \
--print-freq 100 \
--epochs 1 \
--world-size $# \
--multiprocessing-distributed \
--dist-url tcp://${node_arr[0]}:1234 \
--dummy
"
#--dummy /home/u8880716/imagenet_tfrecord
# batch-size: 256 for 1 GPU, 512 for 2 GPU, 2048 for 8 GPU

for (( i=0; i<$NNODES; i++))
do
    if [ $NODE_ADDR == ${node_arr[$i]} ]; then
        echo "run: $NODE_ADDR, $SINGULARITY $CMD --rank $i"
        $SINGULARITY $CMD --rank $i
    fi
done
