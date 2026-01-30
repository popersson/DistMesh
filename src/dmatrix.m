function d=dmatrix(p,xx,yy,dd,varargin)

%   Copyright (C) 2004-2026 Per-Olof Persson. MIT Licensed.

d=interp2(xx,yy,dd,p(:,1),p(:,2),'*linear');
