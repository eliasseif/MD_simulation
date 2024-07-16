#!/usr/bin/bash

#permissões
#sudo chmod +x dock_run.sh
sudo chmod +x patch_dock.Linux
sudo chmod +x pdb_trans


for i in 4GT9 4GTA 1O26 4GTB 5CHP 4GTD 4GTF 1O2A 4KAS 4GTE 5IOS 5IOQ 3G4A 5IOR 4GTC 1O24 1O29 5IOT 7NDW 4KAR 5JFE 3G4C 1O28 4KAT 4GTL 1KQ4 1O27 3N0B 3N0C 1O25 1O2B 7NDZ; do

perl buildParams.pl $i.pdb Oligoventina2.pdb 4.0 drug

./patch_dock.Linux params.txt dock_$i

#grep "#" dock_$i -A 1 >> dock_results.txt

grep "#" dock_$i -A 10 | sort -k1g -t $'|' | awk 'NR == 2' >> dock_results_rod.txt

perl transOutput.pl dock_$i 1

#rm $i.pdb # apagar o arquivo pdb do receptor ao fim

rm dock_$i # apagar o arquivo de resultado de dock


done


#mv dock_$1.1.pdb dock_$1.pdb
