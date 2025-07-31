#!/bin/bash
#SBATCH -A GOV108032           # iService Project id
#SBATCH -J ddp_2x2GPU          # job name
#SBATCH -p gp1d                # partition gtest gp1d, gpNCHC_LLM
#SBATCH --nodes=2              # Maximum number of nodes to be allocated
#SBATCH --cpus-per-task=4      # Number of cores per MPI task
#SBATCH --ntasks-per-node=1    # Number of MPI tasks (i.e. processes)
#SBATCH --gres=gpu:2
##SBATCH -w gpnh003            # get specific node
#SBATCH -o %x_%j.out           # Path to the standard output file

# Get MASTER_ADDR
nodes=$( scontrol show hostnames $SLURM_JOB_NODELIST )
nodes_array=($nodes); echo "node list: " ${nodes_array[*]}
head_node=${nodes_array[0]}; echo "HEAD_NODE=$head_node"
MASTER_ADDR=$(srun --nodes=1 --ntasks=1 -w "$head_node" bash -c "hostname -I | awk '{print \$1}'")

# Get GPU count
IFS=',' read -ra gpu_array <<< "$SLURM_JOB_GPUS"
GPUS_PER_NODE=${#gpu_array[@]}

export CUDA_VISIBLE_DEVICES=0,1 #,2,3,4,5,6,7
export OMP_NUM_THREADS=1

SIF="/work/TWCC_cntr/pytorch_23.08-py3.sif"
export SINGULARITY="singularity run --nv -B /work:/work $SIF"

export LAUNCHER="torchrun \
 --nnodes ${SLURM_JOB_NUM_NODES} \
 --nproc_per_node ${GPUS_PER_NODE} \
 --master_addr $MASTER_ADDR \
 --master_port 1234 \
"
export CMD="multigpu_torchrun.py 10 10"

SECONDS=0
srun --mpi=pmix run.sh

RUNTIME=$SECONDS
HOUR=$(($RUNTIME / 3600)) ;MIN=$(((RUNTIME /60)%60)) ;SEC=$((RUNTIME % 60))
echo -e "\nRuntime:$HOUR:$MIN:$SEC\n"

