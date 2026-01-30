function d = dellipse(p, semiaxes)
%DELLIPSE  Signed distance to ellipse.
%   D = DELLIPSE(P, SEMIAXES)
%
%   P: Nx2 points
%   SEMIAXES: [A, B]
%
%   Based on Inigo Quilez's iterative solver.

%   Copyright (C) 2004-2026 Per-Olof Persson. MIT Licensed.

% "C-style" coding (no array operations) for maximum JIT performance
    
    np = size(p, 1);
    d = zeros(np, 1);

    a = semiaxes(1);
    b = semiaxes(2);
    
    inv_a = 1/a;
    inv_b = 1/b;

    for i = 1:np
        px = abs(p(i,1));
        py = abs(p(i,2));

        % Initial Guess
        qx = a * (px - a);
        qy = b * (py - b);

        % Heuristic: if q.x < q.y start at (0,1), else (1,0)
        % Using 0.01 provides a slight tilt to avoid degenerate axis cases
        if qx < qy
            csx = 0.01; 
            csy = 1.0;
        else
            csx = 1.0; 
            csy = 0.01;
        end
        
        % Normalize the initial vector
        inv_len = 1.0 / sqrt(csx*csx + csy*csy);
        csx = csx * inv_len;
        csy = csy * inv_len;

        % 3. Newton Iteration (Fixed 6 loops)
        for k = 1:6
            % u = ab * cs
            ux = a * csx;
            uy = b * csy;
            
            % v = ab * (-cs.y, cs.x)
            vx = a * (-csy);
            vy = b * csx;
            
            % val_a = dot(p - u, v)
            dx = px - ux;
            dy = py - uy;
            val_a = dx * vx + dy * vy;
            
            % val_c = dot(p - u, u) + dot(v, v)
            val_c = (dx * ux + dy * uy) + (vx * vx + vy * vy);
            
            % val_b = sqrt(c*c - a*a)
            val_b = sqrt(val_c*val_c - val_a*val_a);
            
            % cs = (cs * val_b - swapped_cs * val_a) / val_c
            inv_c = 1.0 / val_c;
            new_csx = (csx * val_b - csy * val_a) * inv_c;
            new_csy = (csy * val_b + csx * val_a) * inv_c;
            
            csx = new_csx;
            csy = new_csy;
        end

        % Final Distance
        final_x = px - a * csx;
        final_y = py - b * csy;
        dist = sqrt(final_x*final_x + final_y*final_y);

        % Sign Check (Interior vs Exterior)
        t1 = px * inv_a;
        t2 = py * inv_b;
        if (t1*t1 + t2*t2) > 1.0
            d(i) = dist;
        else
            d(i) = -dist;
        end
    end
end
