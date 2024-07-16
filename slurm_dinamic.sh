#!/usr/bin/env bash


#SBATCH --job-name "elias_seif"
#SBATCH --export=ALL
#SBATCH -n 20
#SBATCH --mem=16G

echo "Starting a job on the $HOSTNAME"

## ativar gromcs

source /usr/local/gromacs/bin/GMXRC

## diretorio onde será rodado a análise

#cd /home/elias/bioinfo/dinamica/dinamic_7DAV

for i in dock_8GIA; do


echo "15" | gmx pdb2gmx -f $i.pdb -o processed_$i.gro -water spce

gmx editconf -f processed_$i.gro -o newbox_$i.gro -c -d 1.0 -bt cubic

gmx solvate -cp newbox_$i.gro -cs spc216.gro -o solv_$i.gro -p topol.top

gmx grompp -f ions.mdp -c solv_$i.gro -p topol.top -o ions.tpr

echo "13" | gmx genion -s ions.tpr -o solv_ions_$i.gro -p topol.top -pname NA -nname CL -neutral


## Energy minimization
gmx grompp -f minim.mdp -c solv_ions_$i.gro -p topol.top -o em.tpr
gmx mdrun -v -deffnm em

## Constant Number of particles, Volume, and Temperature NVT
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
gmx mdrun -deffnm nvt

## Number of particles, Pressure, and Temperature  NPT
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
gmx mdrun -deffnm npt

## Molecular dinamics
gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr
gmx mdrun -deffnm md_0_1


##Salvar tragetória
echo "1 0" | gmx trjconv -s md_0_1.tpr -f md_0_1.xtc -o md_0_1_noPBC.xtc -pbc mol -center  
#1 0



### TABELAS COM RESULTADOS

echo "10 0" | gmx energy -f em.edr -o 1_potential_$i.xvg    ## POTENCIAL DA MINIMIZAÇÃO
# 10 0
echo "16 0" | gmx energy -f nvt.edr -o 1_temperature_$i.xvg ## TEMPERATURE
#16 0
echo "18 24 0" | gmx energy -f npt.edr -o 1_pres_dens_$i.xvg   ## Pressão e densidade
#18 24 0
echo "4 0" | gmx rms -s md_0_1.tpr -f md_0_1_noPBC.xtc -o 1_rmsd_$i.xvg -tu ns  ## RMSd em relação ao sistema esquilibrado
#4 0
echo "10 0" | mx rms -s em.tpr -f md_0_1_noPBC.xtc -o 1_rmsd_xtal_$i.xvg -tu ns  ## RMSD em ralção a estrutura cristalina
#4 0
echo "1 0" |gmx gyrate -s md_0_1.tpr -f md_0_1_noPBC.xtc -o 1_gyrate_$i.xvg  ## grafico de rotação
#1 0

done

echo "End of JOB"

exit 0
