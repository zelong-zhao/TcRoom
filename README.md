# Strong Correlated Eliashberg Method

Details of this algorithm reference to 'Computational Materials Discovery for Lanthanide Hydrides at high pressure: predicting High Temperature superconductivity'

Evgeny Plekhanov, Francesco Macheda, Zelong Zhao, Yao Wei, Nicola Bonini, and Cedric Weber,   

arXiv:2107.12316 [1]

This is distributed under the GNU Lesser General Public Licence.



# Library and Enviroment

- Script/
  - DMFT2QE.f90 : Fortran script transfer Lorenzen from DMFT Solver to Quantum Espresso format.
  - DMFT_PH.f90 : Fortran main script to run DMFT+DFPT script. 
  - USP2UPF.f90 : Fortran script transfer OTF-USPP to Quantum Espresso format 
  - plot_DOS.plt : gnuplot script to plot density of state. 
  - src/ : bash scripts to replace QE files.
- DATA/ : results used in publication [1] .
- Workflow/ : Tutorial for reproducing data used in the publication.
  - PrH9/
    - DFT+DMFT/ : bash input script of finding electronic properties for strong correlate system
    - DFT+DFPT/ : bash input script of finding phonon and electron-phonon interaction properties for uncorrelated system.
    - DFPT+DMFT/ : bash input script of for  electron-phonon interaction properties for uncorrelated system.

# Enviroment and Install

### Prerequest

- Quantum Espresso PW.x & PH.x V.6.5
- CASTEP DMFT enabled Version.
- USP2UPF.f90 : Fortran script transfer OTF-USPP to Quantum Espresso format. 

### Build

Replace files in Script/src/ to quantum espresso directory and recompile it name as DMFT_Ph.x . 

# Workflow 

PrH9 DMFT+DFPT calculation can be ran with script supported above. In this example, we will show how to use our script to find electron and phonon properties at DMFT level and DFT level especially for Eliashberg equation especially a2f and Tc estimated by Allen Dynes Equation. 

## PrH9 Calculation

WORK FLOW OF CALCULATION PrH9 HERE.

1. DFT+DMFT
2. DFT+DFPT
3. DFPT+DMFT

### DFT+DMFT

Electronic structure calculation with CASTEP+DMFT Solver. In this step, strong correlated system  at DMFT level will be calculated. 

#### Input:

- PrH9.cell : Cell files including atomic positions, lattice constant, Hubbard U, Hund's coupling J, Pseudopotential. 
- PrH9.param : Param files include key parameters for DFT and DMFT. 
- ED.in : Exact diagonalization solver parameters.  

```
$ mpirun -np xx castep.mpi PrH9
```

#### Output: 

- DMFT_DOS_* : List of files for DMFT spectral function.
- PrH9.castep: Basic physical observables. E.g. energy, pressure, ect. 
- *.usp : OTF PP files
- Sigma.dat : 
- ed.sector_bound_file: 

#### Postprocessing: 

To plot the density of states of PrH9.

```
$ gnuplot plot_DOS.plt
```

Generate lorentzen of PrH9 correlated system. FullGF.dat is Greenfunction files generated from DMFT Solver. Using provided script, DMFT2QE.f90 to generate eigenenergies.dat. 

### DFT+DFPT:

In this step, we generate phonon and electron phonon coupling properties. E.g. Eliashberg function $\alpha$2f, electron phonon coupling strength, phonon density of state, phonon spectrum, etc. 

#### Prerequest:

Move praseodymium and hydrogen USP files to quantum espresso UPF format. 

#### Input for Step 1: 

- scf.in : DFT self consistency calculation
- nscf.in : DFT non self consistency calculation
- *.USP : OTF US pseudopotential

```
$ mpirun -np xx pw.x < scf.in > scf.out

$ mpirun -np xx pw.x < nscf.in > nscf.out
```

#### Output for Step 1:

- scf.out : Energy, force, stress tensor, bond length, ect. 
- nscf.out: Fermi level, ect. 

#### Post proccessing for step 1:

Density of states at DFT level will be obtained. 

```
$ dos.x < dos.in > dos.out

$ gnuplot dos.gnuplot
```

#### Input for Step 2: 

DFT+DFPT solver: 

- ph.in: phonon calculation parameters. 
- lambda.in : Neccesary input to find Tc. 

```
$ mpirun -np xx ph.x < ph.in > ph.out
```

#### Post proccessing for step 2:

```
$ q2r.x < q2r.in > q2r.out 

$ matdyn.x < matdyn.freq.in > matdyn.freq.out

$ matdyn.x < matdyn.dos.in > matdyn.dos.out

$ lambda.x < lambda.in > lambda.out

$ gnuplot a2F.gnuplot

$ gnuplot phonon_dos.gnuplot

$ gnuplot phonon_freq.gnuplot
```

#### Output for Step 2: 

- phonon.dos : Phonon density of states. 
- alpha2F.dat : Eliashberg function output. 

### DMFT+DFPT:

Finally the Tc at DMFT level  will be obtained. 

#### Input: 

- Ph_DMFT_DFPT.in : DMFT Phonon correction input, which is as same as ph.in except for recover is true. 

```
$ DMFT_Ph.x < Ph_DMFT_DFPT.in > Ph_DMFT_DFPT.out

$ lambda.x < lambda.in > lambda_dmft.out

$ gnuplot a2F.gnuplot
```

#### Output: 

- Ph_DMFT_DFPT.out : 
- lambda_dmft.out : Tc at DMFT level. 

### Run time: 

Typical runtime @ Tier 2 CSD3. 