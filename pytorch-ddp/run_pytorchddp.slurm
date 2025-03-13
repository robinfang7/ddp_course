#!/bin/bash
#SBATCH -A GOV108032           # iService Project id 
#SBATCH -J ddp_1x2GPU          # job name
#SBATCH -p gp1d                # partition gtest gp1d, gpNCHC_LLM
#SBATCH --nodes=1              # Maximum number of nodes to be allocated
#SBATCH --cpus-per-task=4      # Number of cores per MPI task
#SBATCH --ntasks-per-node=1    # Number of MPI tasks (i.e. processes)
#SBATCH --gres=gpu:2
##SBATCH -w gpnh003            # get specific node
#SBATCH -o %x_%j.out           # Path to the standard output file

nodes=( $( scontrol show hostnames $SLURM_JOB_NODELIST ) )
nodes_array=($nodes)
head_node=${nodes_array[0]}
head_node_ip=$(srun --nodes=1 --ntasks=1 -w "$head_node" hostname --ip-address)
echo "  NODELIST: $SLURM_JOB_NODELIST"
echo "  Master_Node_IP: $head_node_ip"

SECONDS=0
export CUDA_VISIBLE_DEVICES=0,1 #,2,3,4,5,6,7
export OMP_NUM_THREADS=1

SIF="/work/TWCC_cntr/pytorch_23.08-py3.sif"
SINGULARITY="singularity run -B /work:/work --nv $SIF"

TORCHRUN="torchrun \
--nnodes $SLURM_JOB_NUM_NODES \
--nproc_per_node=2 \
--rdzv_id $RANDOM \
--rdzv_backend c10d \
--rdzv_endpoint $head_node_ip \
"

CMD="torchrun --nproc_per_node=2 multigpu_torchrun.py 10 10" # 1 node
#CMD="$TORCHRUN multinode.py 10 10" # multi nodes
RUN="srun $SINGULARITY $CMD"
echo "$RUN"; $RUN

RUNTIME=$SECONDS
HOUR=$(($RUNTIME / 3600)) ;MIN=$(((RUNTIME /60)%60)) ;SEC=$((RUNTIME % 60))
echo -e "\nRuntime:$HOUR:$MIN:$SEC\n"

