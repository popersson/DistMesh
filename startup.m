function startup
% STARTUP  Sets up the MATLAB path for DistMesh

    baseDir = fileparts(mfilename('fullpath'));

    addpath(fullfile(baseDir, 'src'));
    addpath(fullfile(baseDir, 'examples'));

    fprintf('DistMesh paths added.\n');
end
