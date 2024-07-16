#!/usr/bin/env bash


#SBATCH --job-name "ext_1IN7_200ns"
#SBATCH --export=ALL
#SBATCH -n 40
#SBATCH --mem=16G
#SBATCH --gres=gpu:1

echo "Starting a job on the $HOSTNAME"

## ativar gromcs

source /usr/local/gromacs/bin/GMXRC

## Definir parametros para a simulação
gmx convert-tpr -s md_0_1.tpr -extend 100000 -o md_100_200.tpr

## rodando a extensão da dinamica
gmx mdrun -v -deffnm md_100_200 -cpi md_0_1.cpt -noappend

## Concatenar a pre e pós extenssão
gmx trjcat -f md_0_1.xtc md_100_200.part0002.xtc -o md_0_200.xtc

## centralizar a molécula
echo "1 0" | gmx trjconv -s md_100_200.tpr -f md_0_200.xtc -o md_0_200_noPBC.xtc -pbc mol -center  

echo "End of JOB"

exit 0
