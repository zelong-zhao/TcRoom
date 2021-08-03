#!/bin/bash
#SBATCH --account T2-cs085-cpu
#SBATCH --partition cclake
#SBATCH --nodes=20
#SBATCH --ntasks=1120
#SBATCH --time 01:00:00
#SBATCH --output="output.txt"
#SBATCH -J PrH9

#! Number of nodes and tasks per node allocated by SLURM (do not change):
numnodes=$SLURM_JOB_NUM_NODES
numtasks=$SLURM_NTASKS
mpi_tasks_per_node=$(echo "$SLURM_TASKS_PER_NODE" | sed -e  's/^\([0-9][0-9]*\).*$/\1/')

#! (note that SLURM reproduces the environment at submission irrespective of ~/.bashrc):
. /etc/profile.d/modules.sh                # Leave this line (enables the module command)
module purge                               # Removes all modules still loaded
module load rhel7/default-peta4            # REQUIRED - loads the basic environment

workdir="$SLURM_SUBMIT_DIR"  # The value of SLURM_SUBMIT_DIR sets workdir to the directory
                             # in which sbatch is run.
export OMP_NUM_THREADS=1
np=$[${numnodes}*${mpi_tasks_per_node}]

OPT="mpirun -ppn $mpi_tasks_per_node -np $np "

# relex the structure

#eval $OPT "/home/cs-zhao1/q-e_MODIFIED/PW/src/pw.x < relax.in > relax.out"

# scf with a2f large k

#eval $OPT "/home/cs-zhao1/q-e_MODIFIED/PW/src/pw.x -npool 20 < scf.fit.in > scf.fit.out"

# scf without a2f small k

#eval $OPT "/home/cs-zhao1/q-e_MODIFIED/PW/src/pw.x -npool 20 < scf.in > scf.out"

# find DOS dense k
#eval $OPT "/home/cs-zhao1/q-e_MODIFIED/PW/src/pw.x -npool 20 < nscf.in > nscf.out"
#aprun -n 96 dos.x < dos.SmH2.in > dos.SmH2.out

# find phonon
# first step
eval $OPT "/home/cs-zhao1/q-e_MODIFIED/PHonon_original/PH/ph.x -npool 20 < elph.in > elph.out"
# second step DMFT
#eval $OPT "/home/cs-zhao1/q-e_MODIFIED/PHonon/PH/ph.x -npool 20 < elph.in > elph-DMFT.out"

# FFT
#eval "/home/cs-zhao1/q-e_MODIFIED/bin/q2r.x < q2r.in > q2r.out"

#go for isotropic Tc

# PostProccess
#eval "/home/cs-zhao1/q-e_MODIFIED/bin/matdyn.x < matdyn.in.freq > matdyn.out.freq"
#eval "/home/cs-zhao1/q-e_MODIFIED/bin/matdyn.x < matdyn.in.dos > matdyn.out.dos"
#eval "/home/cs-zhao1/q-e_MODIFIED/bin/lambda.x < lambda.in > lambda.out"
#eval "gnuplot a2F.gp"
#Go for aniotropic Tc
#python pp.py
##after nscf
#aprun -n 96 epw.x < epw.in > epw.out
#bug not really working with spin polarized.
