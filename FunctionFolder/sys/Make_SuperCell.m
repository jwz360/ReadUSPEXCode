function [S_coor, S_lat, N_Size] = Make_SuperCell(coor, lat, Dim, flag)
Size = [1; 1; 1];
if length(Dim) == 1
Size= [Dim; Dim; Dim];
elseif length(Dim) == 2
Size= [Dim(1); Dim(2); 1];
elseif length(Dim) == 3
Size= [Dim(1); Dim(2); Dim(3)];
else
disp(['INPUT Dimension ' num2str(Dim) ' is incompatible']);
disp(['will return 1*1*1 cell']);
end
N_Size = prod(Size);
N_atom = size(coor,1);
if N_Size == 1
S_coor = coor;
S_lat  = lat;
else
Matrix = SuperMatrix(0, Size(1)-1, 0, Size(2)-1, 0, Size(3)-1);
if flag == 0 
S_coor   = repmat(coor, [N_Size,1]);
tmp      = repmat(Matrix, [1, N_atom]);
S_Matrix = reshape(tmp',[3,N_atom*N_Size])';
else 
tmp      = repmat(coor, [1, N_Size]);
S_coor   = reshape(tmp',[3,N_atom*N_Size])';
S_Matrix = repmat(Matrix, [N_atom,1]);
end
S_coor  = S_coor + S_Matrix;
S_coor  = S_coor * lat;
S_lat   = repmat(Size,[1,3]).*lat;
S_coor  = S_coor / S_lat;
end
