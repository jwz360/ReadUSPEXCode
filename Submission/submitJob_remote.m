function jobNumber = submitJob_remote(USPEX, Index)
%-------------------------------------------------------------
%This routine is to check if the submitted job is done or not
%2   : whichCluster (default 0, 1: local submission; 2: remote submission)
%C-20GPa : remoteFolder
%-------------------------------------------------------------

%-------------------------------------------------------------
%Step1: To prepare the job script, runvasp.sh
  fp = fopen('runvasp.sh', 'w');
  fprintf(fp, '#!/bin/bash\n');
  fprintf(fp, '#SBATCH --nodes=1\n');
  fprintf(fp, '#SBATCH --ntasks-per-node=48\n');
  fprintf(fp, '#SBATCH --time=168:00:00\n');
  fprintf(fp, '#SBATCH -o nodes\n');
  fprintf(fp, '#SBATCH -J USPEX\n');
  fprintf(fp, 'source /home/chem/intel/bin/compilervars.sh intel64\n');
  fprintf(fp, 'ulimit -s unlimited\n');
  fprintf(fp, 'mpirun -np 48 /home/chem/apps/vasp/vasp5.4.4/All-in-One/vasp_std > vasp.out 2>&1\n');
  fclose(fp);
%------------------------------------------------------------------------------------------------------------
%Step 2: Copy the files to the remote machine

%Step2-1: Specify the PATH to put your calculation folder
Home = ['/home/catml']; %'pwd' of your home directory of your remote machine
Address = 'catml@202.120.101.188'; %your target server: username@address
Path = [Home '/' USPEX '/CalcFold' num2str(Index)];  %Just keep it

%Step2-2: Create the remote directory 
%Please change the ssh/scp command if necessary!!!!!!!!!!!!!!!!!!
try
[a,b]=unix(['ssh ' Address ' mkdir ' USPEX ]);  
catch
end

try
[a,b]=unix(['ssh ' Address ' mkdir ' Path ]);
catch
end

%Step2-3: Copy necessary files
[nothing, nothing] = unix(['scp POSCAR   ' Address ':' Path]);
[nothing, nothing] = unix(['scp INCAR    ' Address ':' Path]);
[nothing, nothing] = unix(['scp POTCAR   ' Address ':' Path]);
[nothing, nothing] = unix(['scp KPOINTS  ' Address ':' Path]);
[nothing, nothing] = unix(['scp runvasp.sh ' Address ':' Path]);

%------------------------------------------------------------------------------------------------------------
%Step 3: to submit the job and get JobID, i.e. the exact command to submit job.
[a,v]=unix(['ssh ' Address ' /usr/bin/qsub ' Path '/runvasp.sh'])

% format: Job 1587349.nagling is submitted to default queue <mono>
end_marker = findstr(v,'.');
if strfind(v,'error')
   jobNumber=0;
else
   jobNumber = v(1:end_marker(1)-1);
end

