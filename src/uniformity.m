function u=uniformity(p,t,fh,varargin)

%   Copyright (C) 2004-2026 Per-Olof Persson. MIT Licensed.

[pc,r]=circumcenter(p,t);
hc=feval(fh,pc,varargin{:});

sz=r./hc;
u=std(sz)/mean(sz);
