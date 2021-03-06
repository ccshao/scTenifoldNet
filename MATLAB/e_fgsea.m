function [s]=e_fgsea(T,rmribo,dbfile)

if nargin<2, rmribo=false; end
if nargin<3, dbfile='all'; end   % bp mf

if isempty(FindRpath)
   error('Rscript.ext is not found.');
end

oldpth=pwd;
pw1=fileparts(which(mfilename));
pth=fullfile(pw1,'thirdparty/fgsea');
cd(pth);
fprintf('CURRENTWDIR = "%s"\n',pth);

if exist('output.txt','file'), delete('output.txt'); end
T.genelist=upper(string(T.genelist));
if rmribo
    [gribo]=get_ribosomalgenes;
    i=~ismember(T.genelist,gribo);
    T=T(i,:);
end
writetable(T,'input.txt');
switch lower(dbfile)
    case 'all'
        RunRcode('script.R');
    case 'bp'
        RunRcode('scrpt_bp.R');
    case 'mf'
        RunRcode('scrpt_mf.R');
end
pause(1);
if exist('output.txt','file')
    s=readtable('output.txt',"Delimiter",',');
else
    s=[];
end
if exist('input.txt','file'), delete('input.txt'); end
if exist('output.txt','file'), delete('output.txt'); end
cd(oldpth);
