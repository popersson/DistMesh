function tests = testDistMesh
%TDISTMESH  Unit tests for DistMesh
%   Run via: results = runtests('tests');

    tests = functiontests(localfunctions);
end

% --- Setup/Teardown ---

function setupOnce(testCase)
    % Robustly find the root directory relative to this test file
    % (Works regardless of where you are running runtests from)
    testFileDir = fileparts(mfilename('fullpath'));
    rootDir = fileparts(testFileDir); % Go up one level to root
    
    addpath(fullfile(rootDir, 'src'));
    addpath(fullfile(rootDir, 'examples'));
end

% --- Actual Tests ---

function testDSegmentCorrectness(testCase)
    % Test the new pure MATLAB dsegment against known values
    
    pv = [0, 0; 2, 0];
    p_test = [1, 0;   1, 1;   3, 0];
    
    d_calc = dsegment(p_test, pv);
    d_true = [0;      1;      1];
    
    testCase.verifyEqual(d_calc, d_true, 'AbsTol', 1e-12, ...
        'dsegment failed to calculate correct distances');
end

function testCircleMeshGeneration(testCase)
    % Verify distmesh2d actually generates a mesh for a unit circle
    fd = @(p) sqrt(sum(p.^2,2)) - 1;
    fh = @huniform;
    h0 = 0.2;
    bbox = [-1,-1; 1,1];
    
    % Use evalc to suppress output, but assign correctly (Fixes 'invalid lhs')
    % We execute the function in the current workspace
    T = evalc('[p, t] = distmesh2d(fd, fh, h0, bbox, []);');
    
    % 1. Check we got points
    testCase.verifyNotEmpty(p, 'Mesh points (p) should not be empty');
    testCase.verifyNotEmpty(t, 'Triangulation (t) should not be empty');
    
    % 2. Check all points are effectively inside the circle (tolerance)
    d_vals = fd(p);
    testCase.verifyLessThan(max(d_vals), 0.05, ...
        'Some mesh points were significantly outside the geometry');
end

function testAllExamples(testCase)
    % Dynamically find and run all example scripts to ensure no crashes.
    
    % 1. Find the examples folder
    testFileDir = fileparts(mfilename('fullpath'));
    rootDir = fileparts(testFileDir);
    exDir = fullfile(rootDir, 'examples');
    
    % 2. Get list of example scripts (excluding the old big demo if kept)
    files = dir(fullfile(exDir, 'ex*.m')); 
    
    if isempty(files)
        % Don't fail if you haven't split them yet, just warn
        return; 
    end
    
    % 3. Run each one headless
    origState = get(0, 'DefaultFigureVisible');
    set(0, 'DefaultFigureVisible', 'off');
    
    try
        for k = 1:length(files)
            scriptName = files(k).name(1:end-2); % Remove .m
            fprintf('Testing example: %s... ', scriptName);
            
            try
                evalc(scriptName); % Run it (suppressing output)
                fprintf('OK\n');
            catch ME
                fprintf('FAILED\n');
                rethrow(ME); % Fail the test
            end
            
            close all; % Cleanup figures
        end
    catch ME
        set(0, 'DefaultFigureVisible', origState);
        rethrow(ME);
    end
    
    set(0, 'DefaultFigureVisible', origState);
end
