function d = dellipsoid(p, semiaxes)
%DELLIPSOID  Signed distance to 3D ellipsoid.
%   D = DELLIPSOID(P, SEMIAXES)
%
%   P: Nx3 points
%   SEMIAXES: [A, B, C]
%
%   Algorithm: Newton's method on the Lagrange multiplier.
%   Finds root 't' of:  sum( (a_i * p_i / (a_i^2 + t))^2 ) - 1 = 0

%   Copyright (C) 2004-2026 Per-Olof Persson. MIT Licensed.

% "C-style" coding (no array operations) for maximum JIT performance
    
    np = size(p, 1);
    d = zeros(np, 1);

    a = semiaxes(1);
    b = semiaxes(2);
    c = semiaxes(3);
    
    a2 = a*a;
    b2 = b*b;
    c2 = c*c;

    for i = 1:np
        px = abs(p(i,1));
        py = abs(p(i,2));
        pz = abs(p(i,3));

        % Heuristic initial Guess for t
        p_max = max(max(px, py), pz);
        if p_max > max(max(a, b), c)
            t = p_max; 
        else
            t = 0.0;
        end

        % Newton Iteration (fixed 8 loops)
        % Solving f(t) = sum( (a*p / (a^2+t))^2 ) - 1 = 0
        for k = 1:8
            % Denominators
            ta = a2 + t;
            tb = b2 + t;
            tc = c2 + t;
            
            % Ratios r = a*px / ta
            ra = (a * px) / ta;
            rb = (b * py) / tb;
            rc = (c * pz) / tc;
            
            % Function value and Derivative
            f = ra*ra + rb*rb + rc*rc - 1.0;
            fp = -2.0 * ( (ra*ra)/ta + (rb*rb)/tb + (rc*rc)/tc );
            
            % Newton Step
            t = t - f / fp;
        end

        % Reconstruct Closest Point 'q'
        qx = (a2 * px) / (a2 + t);
        qy = (b2 * py) / (b2 + t);
        qz = (c2 * pz) / (c2 + t);

        % Final Distance
        dx = px - qx;
        dy = py - qy;
        dz = pz - qz;
        dist = sqrt(dx*dx + dy*dy + dz*dz);

        % Sign Check (Interior vs Exterior)
        v1 = px / a;
        v2 = py / b;
        v3 = pz / c;
        if (v1*v1 + v2*v2 + v3*v3) > 1.0
            d(i) = dist;
        else
            d(i) = -dist;
        end
    end
end
