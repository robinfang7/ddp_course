#!/bin/bash
#SBATCH -A GOV108032           # iService Project id GOV108032
#SBATCH -J imagenet_ds_1GPU    # job name
#SBATCH -p gp1d                # partition gtest gp1d, gpNCHC_LLM
#SBATCH --nodes=1              # Maximum number of nodes to be allocated
#SBATCH --cpus-per-task=4      # Number of cores per MPI task
#SBATCH --ntasks-per-node=1    # Number of MPI tasks (i.e. processes)
#SBATCH --gres=gpu:1
##SBATCH -w gpnh003            # get specific node
#SBATCH -o %x_%j.out           # Path to the standard output file

rm hostfile *.pth.tar

SECONDS=0
#export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7
#export OMP_NUM_THREADS=1

SIF="/work/u8880716/image/pytorch_23.01-ds.sif"
SINGULARITY="singularity run -B /work:/work --nv $SIF"

CMD="deepspeed main.py \
--deepspeed \
--deepspeed_config config/ds_config.json \
-a resnet50 \
--epochs 3 \
--print-freq 100 \
--world-size 1 \
--dummy"
#--multiprocessing-distributed \
# batch-size: 256 for 1 GPU, 512 for 2 GPU, 2048 for 8 GPU

echo "srun $SINGULARITY $CMD"
srun $SINGULARITY $CMD

RUNTIME=$SECONDS
HOUR=$(($RUNTIME / 3600)) ;MIN=$(((RUNTIME /60)%60)) ;SEC=$((RUNTIME % 60))
echo -e "\nRuntime:$HOUR:$MIN:$SEC\n"

