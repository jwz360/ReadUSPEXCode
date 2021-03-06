function WriteIndividual(resFolder, energyUnits)
global ORG_STRUC
global USPEX_STRUC
if nargin == 2 && strcmp(energyUnits, 'kcal/mol')
energyUnits = '(kcal/mol)';
else
energyUnits     = '   (eV)   ';
end
fpath = [ resFolder '/Individuals'];
fp = fopen(fpath, 'w');
fprintf(fp,  'Gen   ID    Origin   Composition    Enthalpy   Volume  Density   Fitness   KPOINTS  SYMM  Q_entr A_order S_order\n');
fprintf(fp, ['                                   ' energyUnits '  (A^3)  (g/cm^3)\n']);
for i=1:length(USPEX_STRUC.POPULATION)
gen      = USPEX_STRUC.POPULATION(i).gen;
symg     = USPEX_STRUC.POPULATION(i).symg;
enth     = USPEX_STRUC.POPULATION(i).Enthalpies(end);
num      = USPEX_STRUC.POPULATION(i).numIons;
fit      = USPEX_STRUC.POPULATION(i).Fitness;
howcome  = USPEX_STRUC.POPULATION(i).howCome;
KPOINTS  = USPEX_STRUC.POPULATION(i).K_POINTS(end,:);
volume   = USPEX_STRUC.POPULATION(i).Vol;
density  = USPEX_STRUC.POPULATION(i).density;
entropy  = USPEX_STRUC.POPULATION(i).struc_entr;
s        = USPEX_STRUC.POPULATION(i).S_order;
order    = USPEX_STRUC.POPULATION(i).order;
comp_format = '[%11s]';
if strcmp(num, 'N/A')
composition = num;
comp_format = '%-13s';
end
volume_format = '%9.3f';
if strcmp(volume, 'N/A')
volume_format = '  %-7s';
end
density_format = '%7.3f';
if strcmp(density, 'N/A')
density_format = '%-6s';
end
kpoints_format = '[%2d %2d %2d]';
if strcmp(KPOINTS, 'N/A')
kpoints_format = '  %-8s';
end
symmetry_format = '%3d';
if strcmp(symg, 'N/A')
symmetry_format = '%-5s';
end
entropy_format = '%6.3f';
if strcmp(entropy, 'N/A')
entropy_format = '%-6s';
end
ao_format = '%6.3f';
if strcmp(order, 'N/A')
ao_format = '%-7s';
end
s_format = '%6.3f';
if strcmp(s, 'N/A')
s_format = '%-6s';
end
if ~strcmp(num, 'N/A')
composition = sprintf('%3d',num);
shift=[4, 2, 1]; 
if size(composition,2)<11
composition=[composition,blanks(shift(length(num)))];
end
end
if isempty(entropy)
entropy = 0;
end
if strcmp(order, 'N/A')
a_o = order;
else
if sum(num)>0
a_o = sum(order)/sum(num);
else
a_o = 0;
end
end
fprintf(fp,['%3d %4d %-11s '  comp_format ' %9.3f ' volume_format ' ' density_format ' %10.3f ' kpoints_format ' ' symmetry_format ' ' entropy_format ' ' ao_format ' ' s_format '\n'], ...
gen, i, howcome, composition,  enth,   volume,           density,         fit,     KPOINTS(:),        symg,               entropy,           a_o,          s);
end
fclose(fp);
