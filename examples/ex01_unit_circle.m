ex_setup
fprintf('Uniform Mesh on Unit Circle\n');
echo on
fd=@(p) sqrt(sum(p.^2,2))-1;
[p,t]=distmesh2d(fd,@huniform,0.2,[-1,-1;1,1],[]);
echo off
fstats(p,t);
