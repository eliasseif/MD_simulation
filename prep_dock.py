
from chimera import runCommand as rc

receptores = ["4GT9", "4GTA", "1O26", "4GTB", "5CHP", "4GTD", "4GTF", "1O2A", "4KAS", "4GTE", "5IOS", "5IOQ", "3G4A", "5IOR", "4GTC", "1O24", "1O29", "5IOT", "7NDW", "4KAR", "5JFE", "3G4C", "1O28", "4KAT", "4GTL", "1KQ4", "1O27", "3N0B", "3N0C", "1O25", "1O2B", "7NDZ"]

for recp in receptores:
    rc("open {}".format(recp))
    rc("~sel")
    rc("sel ~:.a")
    rc("delete sel")
    rc("sel ~protein")
    rc("delete sel")
    rc("write format pdb 0 /home/elias/bioinfo/chimera/olg_dna/{}.pdb".format(recp))
    rc("close session")




