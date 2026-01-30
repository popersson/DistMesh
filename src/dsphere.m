function d=dsphere(p,xc,yc,zc,r)

%   Copyright (C) 2004-2026 Per-Olof Persson. MIT Licensed.

d=sqrt((p(:,1)-xc).^2+(p(:,2)-yc).^2+(p(:,3)-zc).^2)-r;
