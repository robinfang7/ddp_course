#!/bin/bash
#SBATCH -A GOV109092           # iService Project id GOV108032 GOV109092 GOV112012 GOV110171
#SBATCH -J horovod            # job name
#SBATCH -p gtest               # partition gtest gp1d, gpNCHC_LLM
#SBATCH --nodes=1              # Maximum number of nodes to be allocated
#SBATCH --cpus-per-task=4      # Number of cores per MPI task
#SBATCH --ntasks-per-node=2    # Number of MPI tasks (i.e. processes)
#SBATCH --gres=gpu:2
##SBATCH -w gpnh003            # get specific node
#SBATCH -o %x_%j.out           # Path to the standard output file

module purge
SECONDS=0

SIF=/work/TWCC_cntr/tensorflow_24.05-tf2-py3.sif
SINGULARITY="singularity run -B /work:/work --nv $SIF"

CMD="python tensorflow2_keras_mnist.py"


# enable NCCL log
#export NCCL_DEBUG=INFO
srun $SINGULARITY $CMD

RUNTIME=$SECONDS
HOUR=$(($RUNTIME / 3600))
MIN=$(((RUNTIME /60)%60)) 
SEC=$((RUNTIME % 60))
echo -e "\nRuntime:$HOUR:$MIN:$SEC\n"

