function [newcoor, newsymbol, newcharge, newtypes, newbound, newPair] = resortXYZ(coor, symbol, charge, types, bound, Pair, first, radii);
N_max = size(Pair,2);
newcoor = coor;
newList = [];
newsymbol = symbol;
n_atom = size(coor,1);
if first == 0
dist = zeros(3,1);
dist(1) = max(coor(:,1)) - min(coor(:,1));
dist(2) = max(coor(:,2)) - min(coor(:,2));
dist(3) = max(coor(:,3)) - min(coor(:,3));
[tmp1, axes]=max(dist);
[tmp, first]=min(coor(:,axes));
end
newList(1) = first;  
count = 1;       
layer_num   = 1; 
for i = 1: n_atom  
count0 = count;
for j = (count-layer_num+1):count  
ID = newList(j);
for k = 1:Pair(ID,N_max) 
[count, newList] = updateList(newList, Pair(ID,k));
end
end
layer_num = count - count0;
if layer_num ==0 
disp('Search is complete');
break;
end
end
if count < n_atom
disp('The atoms are not fully connected');
quit
end
for i = 1:n_atom 
newcoor(i,:) =   coor(newList(i),:);
newcharge(i,:) = charge(newList(i));
newtypes(i,:) =  types(newList(i));
if ~isempty(symbol)
newsymbol(i)   = symbol(newList(i));
end
newradii(i)   =  radii(newList(i));
newbound(i)   =  bound(newList(i));
end
newPair = find_pair(newcoor, newradii)
function [count, newList]=updateList(newList, ID)
new = 1;
for k = 1:length(newList)
if ID == newList(k)
new = 0;
break;
end
end
if new == 1
newList=[newList; ID];
end
count = length(newList);
