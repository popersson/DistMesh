function d = dsegment(p, pv)
%DSEGMENT  Compute distance from points p to the line segments in pv.
%   D = DSEGMENT(P, PV)

%   Copyright (C) 2004-2026 Per-Olof Persson. See COPYRIGHT.TXT for details.
    
    np = size(p, 1);
    nvs = size(pv, 1);
    d = zeros(np, nvs - 1); 

    % "C-style" coding (no array operations) for maximum JIT performance
    
    % Loop over segments
    for iv = 1:nvs - 1
        pv_x = pv(iv, 1);
        pv_y = pv(iv, 2);
        pv_next_x = pv(iv+1, 1);
        pv_next_y = pv(iv+1, 2);

        % Vector from segment start to end
        vx = pv_next_x - pv_x;
        vy = pv_next_y - pv_y;
        c2 = vx*vx + vy*vy;
        if c2 > 0
            inv_c2 = 1 / c2;
        else
            inv_c2 = 0; 
        end
        
        % Loop over points
        for ip = 1:np
            px = p(ip, 1);
            py = p(ip, 2);

            % Vector from segment start to point
            wx = px - pv_x;
            wy = py - pv_y;
            c1 = vx*wx + vy*wy;

            % Projection factor t
            t = c1 * inv_c2;
            
            % Clamp t between 0 and 1 (Branchless logic)
            t = max(0, min(1, t));
            
            % Calculate closest point on segment
            closest_x = pv_x + t * vx;
            closest_y = pv_y + t * vy;
            
            % Distance
            dpx = px - closest_x;
            dpy = py - closest_y;
            d(ip, iv) = sqrt(dpx*dpx + dpy*dpy);
        end
    end

end
