#!/bin/bash
#SBATCH -A GOV108032           # iService Project id GOV108032
#SBATCH -J ds_fp16_z1_1x8GPU_j16  # job name
#SBATCH -p gp1d                # partition gtest gp1d, gpNCHC_LLM
#SBATCH --nodes=1              # Maximum number of nodes to be allocated
#SBATCH --cpus-per-task=4      # Number of cores per MPI task
#SBATCH --ntasks-per-node=1    # Number of MPI tasks (i.e. processes)
#SBATCH --gres=gpu:8
##SBATCH -w gpnh003            # get specific node
#SBATCH -o %x_%j.out           # Path to the standard output file

SECONDS=0
#export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7
#export OMP_NUM_THREADS=1
rm *.pth.tar

SIF="/work/$(whoami)/image/pytorch_23.01-ds.sif"
SINGULARITY="singularity run -B /work:/work --nv $SIF"

NSYS="nsys profile -t cuda,nvtx,mpi \
 -w true \
 -y 60 -d 60 \
 --force-overwrite true \
 -o ${SLURM_JOB_NAME}_${SLURM_JOBID}"
#

CMD="deepspeed main_nvtx.py \
--deepspeed --deepspeed_config config/ds_fp16_z1_config.json \
-a resnet50 \
-j 16 \
--batch-size 2048 \
--epochs 1 \
--print-freq 10 \
--world-size 1 \
--multiprocessing_distributed \
--dummy"
#--multiprocessing_distributed \
# batch-size: 256 for 1 GPU, 512 for 2 GPUs, 1024 for 4 GPUs, 2048 for 8 GPUs
# ds_config.json ds_fp16_config.json ds_fp16_z1_config.json
#--dummy /work/$(whoami)/dataset/imagenet

RUN="srun $SINGULARITY $CMD"
echo "$RUN"; $RUN

RUNTIME=$SECONDS
HOUR=$(($RUNTIME / 3600)) ;MIN=$(((RUNTIME /60)%60)) ;SEC=$((RUNTIME % 60))
echo -e "\nRuntime:$HOUR:$MIN:$SEC\n"

