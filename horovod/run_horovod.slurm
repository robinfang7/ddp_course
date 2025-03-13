#!/bin/bash
#SBATCH -A GOV108032           # iService Project id 
#SBATCH -J horovod            # job name
#SBATCH -p gtest              # partition gtest gp1d, gpNCHC_LLM
#SBATCH --nodes=2              # Maximum number of nodes to be allocated
#SBATCH --cpus-per-task=4      # Number of cores per MPI task
#SBATCH --ntasks-per-node=2    # Number of MPI tasks (i.e. processes)
#SBATCH --gres=gpu:2
#SBATCH -o %x_%j.out           # Path to the standard output file

#export UCX_NET_DEVICES=mlx5_0:1 ; echo "UCX_NET_DEVICES=mlx5_0:1" # for tensorflow_21.05-tf2-py3
#export UCX_IB_GPU_DIRECT_RDMA=1 ; echo "UCX_IB_GPU_DIRECT_RDMA=1" # for tensorflow_21.05-tf2-py3 enable RDMA
#export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 # for pytorch

SECONDS=0

#SIF="/work/TWCC_cntr/tensorflow_21.11-tf2-py3.sif"
SIF="/work/u8880716/image/tensorflow_21.05-tf2-py3.sif"
#SIF="/work/u8880716/image/pytorch_23.01-py3_horovod.sif"
SINGULARITY="singularity run -B /work:/work --nv $SIF"
CMD="python tensorflow2_keras_mnist.py" # test_horovod.py tensorflow2_keras_mnist.py pytorch_synthetic_benchmark.py
RUN="srun $SINGULARITY $CMD"
echo $RUN; $RUN

RUNTIME=$SECONDS
HOUR=$(($RUNTIME / 3600)) ;MIN=$(((RUNTIME /60)%60)) ;SEC=$((RUNTIME % 60))
echo -e "\nRuntime:$HOUR:$MIN:$SEC\n"
