function d=dmatrix3d(p,xx,yy,zz,dd,varargin)

%   Copyright (C) 2004-2026 Per-Olof Persson. MIT Licensed.

d=interpn(xx,yy,zz,dd,p(:,1),p(:,2),p(:,3),'*linear');
