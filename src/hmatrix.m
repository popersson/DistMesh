function h=hmatrix(p,xx,yy,dd,hh,varargin)

%   Copyright (C) 2004-2026 Per-Olof Persson. MIT Licensed.

h=interp2(xx,yy,hh,p(:,1),p(:,2),'*linear');
