function WriteIndividualOutput_300(Ind_No)
global POP_STRUC
global ORG_STRUC
atomType  = ORG_STRUC.atomType;
resFolder = POP_STRUC.resFolder;
symg        =POP_STRUC.POPULATION(Ind_No).symg;
count       =POP_STRUC.POPULATION(Ind_No).Number;
INIT_numIons=POP_STRUC.POPULATION(Ind_No).INIT_numIons;
INIT_LAT    =POP_STRUC.POPULATION(Ind_No).INIT_LAT;
INIT_COORD  =POP_STRUC.POPULATION(Ind_No).INIT_COORD;
Write_POSCAR(atomType, count, symg, INIT_numIons, INIT_LAT, INIT_COORD);
[a,b]=unix([' cat POSCAR      >> ' POP_STRUC.resFolder '/gatheredPOSCARS_unrelaxed']);
lattice = POP_STRUC.POPULATION(Ind_No).LATTICE;
coor    = POP_STRUC.POPULATION(Ind_No).COORDINATES;
numIons = POP_STRUC.POPULATION(Ind_No).numIons;
order   = POP_STRUC.POPULATION(Ind_No).order;
if ORG_STRUC.doSpaceGroup == 1
[nothing, current_path] = unix('pwd');
current_path(end) = [];
cd([ORG_STRUC.homePath '/CalcFoldTemp']);
POP_STRUC.POPULATION(Ind_No).symg = anasym_stokes(lattice, coor, numIons, atomType, ORG_STRUC.SGtolerance);
symg        =POP_STRUC.POPULATION(Ind_No).symg;
cd(current_path)
[a,b]=unix(['echo data_findsym-STRUC-' num2str(count) '            >> ' resFolder '/symmetrized_structures.cif']);
[a,b]=unix(['cat CalcFoldTemp/symmetrized.cif                    >> ' resFolder '/symmetrized_structures.cif']);
end
Write_POSCAR(atomType, count, symg, numIons, lattice, coor);
Write_POSCAR_order(atomType, count, symg, numIons, lattice, coor, order);
[a,b]=unix([' cat POSCAR      >> ' POP_STRUC.resFolder '/gatheredPOSCARS']);
[a,b]=unix([' cat POSCAR_order >>' POP_STRUC.resFolder '/gatheredPOSCARS_order']);
update_USPEX_INDIVIDUAL(POP_STRUC.POPULATION(Ind_No), resFolder, ...
POP_STRUC.generation, atomType);
WriteOUTPUT(count, resFolder);
