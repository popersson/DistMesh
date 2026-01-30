function meshdemo2d
%MESHDEMO2D  Run all DistMesh examples in sequence
%   Finds and executes all 'ex*.m' files in the same directory.

    % 1. Locate the examples folder (relative to this script)
    %    This ensures it works whether called from root or inside examples/
    baseDir = fileparts(mfilename('fullpath'));
    
    % 2. Find all 'ex*.m' files
    files = dir(fullfile(baseDir, 'ex*.m'));
    
    % Sort them alphabetically (ex01, ex02...) to ensure order
    [~, idx] = sort({files.name});
    files = files(idx);

    if isempty(files)
        fprintf('No ex*.m files found in %s\n', baseDir);
        fprintf('Please ensure you have split the examples into separate files.\n');
        return;
    end

    % 3. Initialize Figure
    fprintf('Found %d examples. Starting interactive demo...\n', length(files));
    fprintf('---------------------------------------------------\n');
    figure(1);
    
    for k = 1:length(files)
        scriptName = files(k).name;
        fullPath = fullfile(baseDir, scriptName);
        
        % Reset the figure for the next example
        figure(1);
        clf; 
        
        fprintf('Running %s... ', scriptName(1:end-2));
        
        % Run the script safely
        try
            run(fullPath);
        catch ME
            fprintf('\n[ERROR] %s failed: %s\n', scriptName, ME.message);
        end
        
        % The classic "Pause" experience
        fprintf('\n(press any key)\n\n');
        pause;
    end
    
    fprintf('All examples completed.\n');
    close(1);
end
