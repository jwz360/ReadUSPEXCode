function Transmutation_301(Ind_No)
global POOL_STRUC
global ORG_STRUC
global OFF_STRUC
goodMutant = 0;
goodComposition = 0;
count = 0;
while goodMutant + goodComposition ~= 2
count = count + 1;
if count > 50
%disp('failed to do transmuation in 50 attempts, switch to Random');
USPEXmessage(507,'',0);
Random_301(Ind_No);
break;
end
toTransMutate = find (ORG_STRUC.tournament>RandInt(1,1,[0,max(ORG_STRUC.tournament)-1]));
Ind = toTransMutate(end);
[TRANSMUT,goodFather,noOfSwapsNow,numIons, numBlocks] = swapIons_transmutation_final(Ind);
if isempty(TRANSMUT) 
goodMutant = 0;
else
temp_potLat = POOL_STRUC.POPULATION(Ind).LATTICE;
volLat = det(temp_potLat);
latVol = 0;
for it = 1 : length(ORG_STRUC.latVolume)
latVol = latVol + numIons(it)*ORG_STRUC.latVolume(it);
end
ratio = (latVol/volLat)^(1/3);
lat= temp_potLat*ratio;
goodMutant = distanceCheck(TRANSMUT, lat , numIons, ORG_STRUC.minDistMatrice);
goodComposition = CompositionCheck(numBlocks);
end
if goodMutant + goodComposition == 2
disp(['Structure ' num2str(Ind_No) ' generated by transmutation']);
info_parents             = struct('parent1', {},'noOfTransNow', {}, 'enthalpy', {});
info_parents(1).parent   =num2str(POOL_STRUC.POPULATION(Ind).Number);
info_parents.noOfTransNow=noOfSwapsNow;
info_parents.enthalpy    =POOL_STRUC.POPULATION(Ind).enthalpy;
OFF_STRUC.POPULATION(Ind_No).Parents     = info_parents;
OFF_STRUC.POPULATION(Ind_No).COORDINATES = TRANSMUT;
OFF_STRUC.POPULATION(Ind_No).LATTICE     = lat;
OFF_STRUC.POPULATION(Ind_No).howCome     = 'TransMutate';
OFF_STRUC.POPULATION(Ind_No).numIons     = numIons;
OFF_STRUC.POPULATION(Ind_No).numBlocks   = numBlocks;
end
end
