function LatMutation_310(Ind_No)
global POP_STRUC
global ORG_STRUC
global OFF_STRUC
goodMutant = 0;
goodMutLattice = 0;
count = 1;
while goodMutant + goodMutLattice ~= 2
count = count + 1;
if count > 50
%disp('failed to do Latmutation in 50 attempts, switch to Random');
USPEXmessage(512,'',0);
Random_310(Ind_No);
break;
end
toMutate = find (ORG_STRUC.tournament>RandInt(1,1,[0,max(ORG_STRUC.tournament)-1]));
ind = POP_STRUC.ranking(toMutate(end));
MtypeLIST = POP_STRUC.POPULATION(ind).MtypeLIST;
numMols   = POP_STRUC.POPULATION(ind).numMols;
lattice   = POP_STRUC.POPULATION(ind).LATTICE;
numIons   = POP_STRUC.POPULATION(ind).numIons;
typesAList= POP_STRUC.POPULATION(ind).typesAList;
[MUT_LAT,strainMatrix] = lattice_Mutation(POP_STRUC.POPULATION(ind).LATTICE);
tempMOLS = POP_STRUC.POPULATION(ind).MOLECULES;
for i=1:sum(numMols)
coor1(i,:)=POP_STRUC.POPULATION(ind).MOLECULES(i).MOLCOORS(1,:);
end
[coord, MUT_LAT] = optLattice(coor1, MUT_LAT);
absolute=coord-coor1;
for j=1:sum(numMols)
for k=1:length(ORG_STRUC.STDMOL(MtypeLIST(j)).types)
tempMOLS(j).MOLCOORS(k,:)=POP_STRUC.POPULATION(ind).MOLECULES(j).MOLCOORS(k,:)+absolute(j,:);
end
end
goodMutant = newMolCheck (tempMOLS,MUT_LAT,MtypeLIST,ORG_STRUC.minDistMatrice);
goodMutLattice = latticeCheck(MUT_LAT);
if goodMutant + goodMutLattice == 2
for inder = 1: sum(numMols)
tempMOLS(inder).ZMATRIX = real(NEW_coord2Zmatrix(tempMOLS(inder).MOLCOORS,ORG_STRUC.STDMOL(MtypeLIST(inder)).format));
end
OFF_STRUC.POPULATION(Ind_No).MOLECULES = tempMOLS;
OFF_STRUC.POPULATION(Ind_No).LATTICE =  MUT_LAT;
OFF_STRUC.POPULATION(Ind_No).numIons = numIons;
OFF_STRUC.POPULATION(Ind_No).numMols = numMols;
OFF_STRUC.POPULATION(Ind_No).MtypeLIST = MtypeLIST;
OFF_STRUC.POPULATION(Ind_No).typesAList = typesAList;
info_parents = struct('parent', {},'strainMatrix', {}, 'enthalpy', {});
info_parents(1).parent= num2str(POP_STRUC.POPULATION(ind).Number);
info_parents.enthalpy = POP_STRUC.POPULATION(ind).Enthalpies(end);
info_parents.strainMatrix=strainMatrix;
OFF_STRUC.POPULATION(Ind_No).Parents = info_parents;
OFF_STRUC.POPULATION(Ind_No).howCome = ' LatMutate ';
disp(['Structure ' num2str(Ind_No) '  generated by latmutation']);
end
end
