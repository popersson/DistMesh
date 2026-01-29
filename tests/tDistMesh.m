function tests = tDistMesh
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
