#!/bin/bash
#SBATCH -A GOV108032           # iService Project id GOV108032
#SBATCH -J ds_2x2GPU           # job name
#SBATCH -p gp1d                # partition gtest gp1d, gpNCHC_LLM
#SBATCH --nodes=2              # Maximum number of nodes to be allocated
#SBATCH --cpus-per-task=4      # Number of cores per MPI task
#SBATCH --ntasks-per-node=1    # Number of MPI tasks (i.e. processes)
#SBATCH --gres=gpu:2
##SBATCH -w gpnh003            # get specific node
#SBATCH -o %x_%j.out           # Path to the standard output file

#nodes=$( scontrol show hostnames $SLURM_JOB_NODELIST ) 
#nodes_array=($nodes) ; echo "node list:" ${nodes_array[*]}
#head_node=${nodes_array[0]}
#head_node_ip=$(srun --nodes=1 --ntasks=1 -w "$head_node" hostname --ip-address)

function makehostfile() {
perl -e '$slots=split /,/, $ENV{"SLURM_STEP_GPUS"};
$slots=2 if $slots==0; # workaround 8 gpu machines
@nodes = split /\n/, qx[scontrol show hostnames $ENV{"SLURM_JOB_NODELIST"}];
print map { "$b$_ slots=$slots\n" } @nodes'
}
makehostfile > hostfile

export OMP_NUM_THREADS=1
rm hostfile *.pth.tar

SECONDS=0

SIF="/work/u8880716/image/pytorch_23.01-ds.sif"
SINGULARITY="singularity run -B /work:/work --nv $SIF"
LAUNCHER="deepspeed --hostfile=hostfile" 
CMD="$LAUNCHER main.py \
--deepspeed \
--deepspeed_config config/ds_fp16_z1_config.json \
-a resnet50 \
--batch-size 512 \
--epochs 1 \
--print-freq 100 \
--world-size 2 \
--multiprocessing_distributed \
--dummy"
#--world-size 2 \
#--multiprocessing_distributed \
# batch-size: 256 for 1 GPU, 512 for 2 GPU, 2048 for 8 GPU

RUN="srun $SINGULARITY $CMD"
echo $RUN; $RUN

RUNTIME=$SECONDS
HOUR=$(($RUNTIME / 3600)) ;MIN=$(((RUNTIME /60)%60)) ;SEC=$((RUNTIME % 60))
echo -e "\nRuntime:$HOUR:$MIN:$SEC\n"

