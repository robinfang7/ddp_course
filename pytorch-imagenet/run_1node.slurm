#!/bin/bash
#SBATCH -A GOV108032           # iService Project id
#SBATCH -J resnet_2GPU         # job name
#SBATCH -p gp1d                # partition gtest gp1d, gpNCHC_LLM
#SBATCH --nodes=1              # Maximum number of nodes to be allocated
#SBATCH --cpus-per-task=4      # Number of cores per MPI task
#SBATCH --ntasks-per-node=1    # Number of MPI tasks (i.e. processes)
#SBATCH --gres=gpu:2
#SBATCH -o %x_%j.out           # Path to the standard output file

SECONDS=0
export CUDA_VISIBLE_DEVICES=0,1 #,2,3,4,5,6,7
export OMP_NUM_THREADS=1

SIF="/work/TWCC_cntr/pytorch_23.08-py3.sif"
SINGULARITY="singularity run -B /work:/work --nv $SIF"

CMD="python main.py \
-a resnet50 \
--batch-size 128 \
--print-freq 100 \
--epochs 5 \
--rank 0 \
--world-size 1 \
--multiprocessing-distributed \
--dist-url tcp://127.0.0.1:1234 \
--dummy"
#--multiprocessing-distributed \ for multi gpu
#--dist-url env:// tcp://127.0.0.1:1234
#--dummy /work/u8880716/dataset/imagenet
#--batch-size: 256 for 1 GPU, 512 for 2 GPU, 2048 for 8 GPU

echo "srun $SINGULARITY $CMD"
srun $SINGULARITY $CMD

RUNTIME=$SECONDS
HOUR=$(($RUNTIME / 3600)) ; MIN=$(((RUNTIME /60)%60)) ; SEC=$((RUNTIME % 60))
echo -e "\nRuntime:$HOUR:$MIN:$SEC\n"

