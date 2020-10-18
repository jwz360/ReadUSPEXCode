function [coor, lat] = Read_SIESTA_Structure()
coor = [];
lat = zeros(3,3);
if ~exist('OUT.UCELL.ZMATRIX')
fp = fopen('siesta.STRUCT_OUT');
count=1;
for i=1:3
tmp = fgetl(fp);
lat(i,:) = str2num(tmp);
end
tmp = fgetl(fp);
N_atom = sum(str2num(tmp));
for i = 1:N_atom
tmp = str2num(fgetl(fp));
coor(count,:) = tmp(3:5);
count = count+1;
end
coor = coor - floor(coor);
fclose(fp);
else 
fp = fopen('OUT.UCELL.ZMATRIX');
running = 1;
count = 1;
dolat = 0;
docoor = 0;
while running
a = fgetl(fp);
if findstr(a, '%block LatticeVectors')
dolat = 1;
if findstr(a, '%endblock LatticeVectors')
dolat=0;
elseif findstr(a, '%block Zmatrix')
docoor = 1;
elseif findstr(a, '%endblock Zmatrix')
running=0;
docoor = 0;
elseif ~findstr(a, 'molecule_cartesian')
if dolat==1
optlat(1,:) = str2num(a);
optlat(2,:) = str2num(fgetl(fp));
optlat(3,:) = str2num(fgetl(fp));
elseif  (docoor==1)  
tmp = str2num(a);
coor(count,:) = tmp(5:7);
count = count + 1;
end
end
end
fclose(fp);
end
end
