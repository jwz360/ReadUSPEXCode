function [numIons, numBlocks, offspring,potentialLattice,fracFrac,dimension,offset,fracLattice] = heredity_finalMP_var(parents, dimension)
global POOL_STRUC
global ORG_STRUC
Vector = zeros(1,length(ORG_STRUC.atomType));
for i = 1 : length(ORG_STRUC.atomType)
Vector(i)= 2*str2num(covalentRadius(ceil(ORG_STRUC.atomType(i))));
end
minSlice = min(Vector);
maxSlice = max(Vector);
medSlice = (maxSlice+minSlice)/2;
length1 = latConverter(POOL_STRUC.POPULATION(parents(1)).LATTICE);
length2 = latConverter(POOL_STRUC.POPULATION(parents(2)).LATTICE);
Np_max = max(length1(dimension), length2(dimension))/medSlice + 1;
optim = 1000;
for Np_index=1:Np_max
fracLat = ones(1, Np_index)/Np_index;
temp_potLat = zeros(3,3);
for i = 1 : Np_index 
temp_potLat = temp_potLat + fracLat(i)*POOL_STRUC.POPULATION(parents(i)).LATTICE;
end
temp_potLat = temp_potLat/det(temp_potLat);
latVol = 0;
for i = 1 : Np_index
latVol = latVol + fracLat(i)*det(POOL_STRUC.POPULATION(parents(i)).LATTICE);
end
lat_M = temp_potLat*latVol;
lat_H = latConverter(lat_M);
optim1 = abs(lat_H(dimension)-Np_index*medSlice);
if optim1 < optim
optim = optim1;
Np = Np_index;
potentialLattice=lat_M;     
end
end
for i=1:Np
fracFrac(i) = fracLat(i)*i;
end
nIonsMax = 0;
for i = 1 : Np
if sum(POOL_STRUC.POPULATION(parents(i)).numIons) > nIonsMax 
nIonsMax = sum(POOL_STRUC.POPULATION(parents(i)).numIons);
end
end
parent = -1*ones(nIonsMax,3,Np);
for i2 = 1 : 3
for i3 = 1 : Np
for i1 = 1 : sum(POOL_STRUC.POPULATION(parents(i3)).numIons)
parent(i1,i2,i3) = POOL_STRUC.POPULATION(parents(i3)).COORDINATES(i1,i2);
end
end
end
if rand(1) > ORG_STRUC.percSliceShift
offset = rand(Np,1);
for i = 1 : Np
parent(:,dimension,i) = parent(:,dimension,i)+offset(i,1);
parent(:,dimension,i) = parent(:,dimension,i) - floor(parent(:,dimension,i));
end
else
offset = rand(3*Np,1);
for i = 1 : Np
parent(:,1,i)= parent(:,1,i)+offset((i-1)*3+1,1);
parent(:,2,i)= parent(:,2,i)+offset((i-1)*3+2,1);
parent(:,3,i)= parent(:,3,i)+offset((i-1)*3+3,1);
end
parent = parent - floor(parent);
end
for i2 = 1 : 3
for i3 = 1 : Np
for i1 = sum(POOL_STRUC.POPULATION(parents(i3)).numIons)+1 : nIonsMax
parent(i1,i2,i3) = -1;
end
end
end
L_cut = zeros(1,Np);
Lchar = zeros(1,Np);
Nslabs = zeros(1,Np);
for i = 1 : Np
lat1 = POOL_STRUC.POPULATION(parents(i)).LATTICE;
if dimension == 1 
L_cut(i) = abs(det(lat1)/norm(cross(lat1(2,:),lat1(3,:))));
elseif dimension == 2
L_cut(i) = abs(det(lat1)/norm(cross(lat1(1,:),lat1(3,:))));
else
L_cut(i) = abs(det(lat1)/norm(cross(lat1(1,:),lat1(2,:))));
end
Lchar(i) = 0.5*power(abs(det(lat1))/sum(POOL_STRUC.POPULATION(parents(i)).numIons), 1/3); 
Nslabs(i) = round(L_cut(i)/(Lchar(i)+(L_cut(i)-Lchar(i))));
end
%disp(['Number of slabs = ' num2str(Nslabs)]);
ord = zeros(1,Np);
whichIons = zeros(nIonsMax,Np);
whichIonsN = zeros(Np,1);
whichI = find((parent(:,dimension,1)) < fracFrac(1) & (parent(:,dimension,1) > -0.5));
whichIonsN(1,1) = length(whichI);
for j = 1:length(whichI)
whichIons(j,1) = whichI(j);
end
if whichIonsN(1,1) > 0
ord(1) = sum(POOL_STRUC.POPULATION(parents(1)).order(whichI))/whichIonsN(1,1);
end
for i = 2 : Np 
whichI = find(parent(:,dimension,i)<fracFrac(i) & parent(:,dimension,i)>=fracFrac(i-1));
whichIonsN(i,1) = length(whichI);
for j = 1:length(whichI)
whichIons(j,i) = whichI(j);
end
if whichIonsN(i,1) > 0
ord(i) = sum(POOL_STRUC.POPULATION(parents(i)).order(whichI))/whichIonsN(i,1);
end
end
for i = 1 : max(Nslabs)     
offset_extra = rand(Np,1);
for j = 1 : Np
if Nslabs(j) <= i
parent(:,dimension,j) = parent(:,dimension,j) + offset_extra(j);
parent(:,dimension,j) = parent(:,dimension,j) - floor(parent(:,dimension,j));
end
end
for i2 = 1 : 3
for i3 = 1 : Np
for i1 = sum(POOL_STRUC.POPULATION(parents(i3)).numIons)+1 : nIonsMax
parent(i1,i2,i3) = -1;
end
end
end
ord_extra = zeros(Np,1);
whichIons_extra = zeros(nIonsMax,Np);
whichIonsN_extra = zeros(Np,1);
if Nslabs(1) <= i
whichI = find((parent(:,dimension,1)) < fracFrac(1) & (parent(:,dimension,1) > -0.5));
whichIonsN_extra(1,1) = length(whichI);
for j = 1 : length(whichI)
whichIons_extra(j,1) = whichI(j);
end
if whichIonsN_extra(1,1) > 0
ord_extra(1) = sum(POOL_STRUC.POPULATION(parents(1)).order(whichI))/whichIonsN_extra(1,1);
end
end
for i1 = 2 : Np 
if Nslabs(i1) <= i
whichI = find(parent(:,dimension,i1)<fracFrac(i1) & parent(:,dimension,i1)>=fracFrac(i1-1));
whichIonsN_extra(i1,1) = length(whichI);
for j = 1 : length(whichI)
whichIons_extra(j,i1) = whichI(j);
end
if whichIonsN_extra(i1,1) > 0
ord_extra(i1) = sum(POOL_STRUC.POPULATION(parents(i1)).order(whichI))/whichIonsN_extra(i1,1);
end
end
end
for j = 1 : Np
if Nslabs(j) <= i
parent(:,dimension,j) = parent(:,dimension,j) - offset_extra(j);
parent(:,dimension,j) = parent(:,dimension,j) - floor(parent(:,dimension,j));
for i2 = 1 : 3
for i3 = 1 : Np
for i1 = sum(POOL_STRUC.POPULATION(parents(i3)).numIons)+1 : nIonsMax
parent(i1,i2,i3) = -1;
end
end
end
end
end
end
offspring = zeros(0,3);
ionCount = zeros(length(ORG_STRUC.atomType),1);
ionCh = zeros(Np, length(ORG_STRUC.atomType)+1);
for i = 1 : Np
for ind = 1:length(POOL_STRUC.POPULATION(parents(i)).numIons)
ionChange(ind) = sum(POOL_STRUC.POPULATION(parents(i)).numIons(1:ind));
end
ionCh(i, 2:end) = ionChange;
end
maxBlocks = POOL_STRUC.POPULATION(parents(1)).numBlocks;
for i = 2 : Np
maxBlocks = maxBlocks + POOL_STRUC.POPULATION(parents(i)).numBlocks;
end
child = zeros(1, length(ORG_STRUC.atomType));
for atomN = 1 : length(ORG_STRUC.atomType)
ionsN = zeros(Np,1);
for i = 1 : Np 
smaller1 = find(whichIons(1:whichIonsN(i,1),i) <= ionCh(i, atomN+1));
ion      = find(whichIons(smaller1,i) > ionCh(i,atomN));
ionsN(i,1) = length(ion);
end
child(atomN) = sum(ionsN);
end
[desired_comp, desired_blocks] = findDesiredComposition(maxBlocks, ORG_STRUC.numIons, child);
for ind = 1:length(ORG_STRUC.atomType)
ions = zeros(nIonsMax,Np);
smaller = zeros(nIonsMax,Np);
ionsN = zeros(Np,1);
for i = 1:Np 
smaller1 = find(whichIons(1:whichIonsN(i,1),i) <= ionCh(i, ind+1));
ion      = find(whichIons(smaller1,i) > ionCh(i,ind));
ionsN(i,1) = length(ion);
for j = 1:length(smaller1)
smaller(j,i) = smaller1(j);
end
for j = 1:length(ion)
ions(j,i) = ion(j);
end
for j = length(ion)+1:nIonsMax
ions(j,i) = 0;
end
end
ionCount(ind,1) = sum(ionsN);
candidates = [];
if ionCount(ind,1) < desired_comp(ind)
howmany = desired_comp(ind) - ionCount(ind,1);
maxIons = 0;
for i=1:Np
if POOL_STRUC.POPULATION(parents(i)).numIons(ind)>maxIons
maxIons = POOL_STRUC.POPULATION(parents(i)).numIons(ind);
end
end
filled = zeros(Np, maxIons);
for xy = 1:howmany
flag = 1;
while flag
ins_par = RandInt(1,1,[1,Np]);
tempInd = (ionCh(ins_par, ind)+1:ionCh(ins_par, ind+1)); 
natoms = length(tempInd);
if natoms >0
atoms = sort_order(POOL_STRUC.POPULATION(parents(ins_par)).order, tempInd, 'descend');
ins_ind = tempInd(atoms(1))-ionCh(ins_par, ind);
for i = 1 : natoms
if filled(ins_par, tempInd(atoms(i))-ionCh(ins_par, ind)) == 0
ins_ind = tempInd(atoms(i))-ionCh(ins_par, ind);
break;
end
end
if filled(ins_par, ins_ind) == 0
flag = 0;
end;
coord1 = parent(ionCh(ins_par, ind)+ins_ind,dimension,ins_par);
if ins_par == 1
if coord1 < fracFrac(1)
flag = 1;
end  
elseif (coord1 >= fracFrac(ins_par-1)) & (coord1 < fracFrac(ins_par))
flag = 1;
end;
filled(ins_par, ins_ind) = 1;
end
end
filled(ins_par, ins_ind) = 1;
candidates = cat(1,candidates,parent(ionCh(ins_par, ind)+ins_ind,:,ins_par));
end
elseif ionCount(ind,1) > desired_comp(ind)
howmany = ionCount(ind,1) - desired_comp(ind);
ionsN1 = ionsN;
order = zeros(1,ionCount(ind,1));
ord_ind = 1;
for i = 1 : Np
for j = 1 : ionsN(i,1)
order(ord_ind) = POOL_STRUC.POPULATION(parents(i)).order(whichIons(smaller(ions(j,i),i),i));
ord_ind = ord_ind + 1;
end
end
tournament = zeros(ionCount(ind,1),1);
tournament(ionCount(ind,1)) = 1;
for loop = 2:ionCount(ind,1)
tournament(end-loop+1)= tournament(end-loop+2)+loop;
end
[junk, ranking] = sort(order); 
atom_rank = randperm(max(tournament));
atoms = zeros(length(tournament),1);
chosen = zeros(ionCount(ind,1),1);
j1 = 1;
for i1 = 1:max(tournament) 
at1 = find (tournament > (atom_rank(i1)-1));
if chosen(ranking(at1(end))) == 0
chosen(ranking(at1(end))) = 1;
atoms(j1) = ranking(at1(end));
j1 = j1 + 1;
end
end
for xy = 1:howmany
flag = 1;
while flag
del_ind = atoms(end-xy+1); 
parent_ind = 1;
while del_ind > ionsN(parent_ind,1)
del_ind = del_ind - ionsN(parent_ind,1);
parent_ind = parent_ind + 1;
end
if ions(del_ind, parent_ind) > 0
flag = 0;
end  
end
ions(del_ind, parent_ind) = 0;
end
end
addOn = candidates;
for in1 = 1:Np
for in2 = 1:ionsN(in1)
if ions(in2, in1) > 0
addOn = cat(1,addOn, parent(whichIons(smaller(ions(in2,in1),in1),in1),:,in1));
end; 
end;
end;
offspring = cat(1,offspring,addOn);
end
numIons = desired_comp;
numBlocks = desired_blocks;
