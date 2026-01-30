function p=protate(p,phi)

%   Copyright (C) 2004-2026 Per-Olof Persson. MIT Licensed.

A=[cos(phi),-sin(phi);sin(phi),cos(phi)];
p=p*A;
