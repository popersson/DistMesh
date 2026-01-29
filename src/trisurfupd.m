function [t,t2t,t2n] = trisurfupd(t, t2t, t2n, p)
%TRISURFUPD

% "C-style" coding (no array operations) for maximum JIT performance
% See original code in trisurfupd_ref for better readability
    
    C_QUAL = 6.928203230275509; % 4 * sqrt(3)
    
    px = p(:,1);
    py = p(:,2);
    pz = p(:,3);

    nt = size(t,1);
    for t1 = 1:nt
        for n1 = 1:3
            t2 = t2t(t1,n1);
            
            % Only process if neighbor exists
            if t2 > 0
                % ------------------------------------------------------------
                % Geometric properties - triangle 1
                % ------------------------------------------------------------

                % Indices
                ti1 = t(t1,1); ti2 = t(t1,2); ti3 = t(t1,3);
                
                % Coordinates (Scalar load)
                x1 = px(ti1); y1 = py(ti1); z1 = pz(ti1);
                x2 = px(ti2); y2 = py(ti2); z2 = pz(ti2);
                x3 = px(ti3); y3 = py(ti3); z3 = pz(ti3);

                % Edges T1 (d12, d13)
                d1x = x2 - x1; d1y = y2 - y1; d1z = z2 - z1;
                d2x = x3 - x1; d2y = y3 - y1; d2z = z3 - z1;
                
                % Cross Product T1 (nx1)
                nx1 = d1y*d2z - d1z*d2y;
                ny1 = d1z*d2x - d1x*d2z;
                nz1 = d1x*d2y - d1y*d2x;
                
                % Norm Squared & Vol T1
                nsq1 = nx1*nx1 + ny1*ny1 + nz1*nz1;
                vol1 = sqrt(nsq1); % This is 2*Area
                
                % Denominator T1 (Sum of edge lengths squared)
                % We need d23 squared as well:
                d3x = x3 - x2; d3y = y3 - y2; d3z = z3 - z2;
                
                len12sq = d1x*d1x + d1y*d1y + d1z*d1z;
                len13sq = d2x*d2x + d2y*d2y + d2z*d2z;
                len23sq = d3x*d3x + d3y*d3y + d3z*d3z;
                
                q1 = (C_QUAL * 0.5 * vol1) / (len12sq + len13sq + len23sq);

                % ------------------------------------------------------------
                % Geometric properties - triangle 2
                % ------------------------------------------------------------

                tj1 = t(t2,1); tj2 = t(t2,2); tj3 = t(t2,3);
                
                tx1 = px(tj1); ty1 = py(tj1); tz1 = pz(tj1);
                tx2 = px(tj2); ty2 = py(tj2); tz2 = pz(tj2);
                tx3 = px(tj3); ty3 = py(tj3); tz3 = pz(tj3);

                % Edges T2
                td1x = tx2 - tx1; td1y = ty2 - ty1; td1z = tz2 - tz1;
                td2x = tx3 - tx1; td2y = ty3 - ty1; td2z = tz3 - tz1;
                
                % Cross Product T2 (nx2)
                nx2 = td1y*td2z - td1z*td2y;
                ny2 = td1z*td2x - td1x*td2z;
                nz2 = td1x*td2y - td1y*td2x;
                
                nsq2 = nx2*nx2 + ny2*ny2 + nz2*nz2;
                vol2 = sqrt(nsq2);
                
                td3x = tx3 - tx2; td3y = ty3 - ty2; td3z = tz3 - tz2;
                
                tlen12sq = td1x*td1x + td1y*td1y + td1z*td1z;
                tlen13sq = td2x*td2x + td2y*td2y + td2z*td2z;
                tlen23sq = td3x*td3x + td3y*td3y + td3z*td3z;
                
                q2 = (C_QUAL * 0.5 * vol2) / (tlen12sq + tlen13sq + tlen23sq);
                
                % ------------------------------------------------------------
                % --- CHECK OLD QUALITY ---
                minqold = min(q1, q2);
                if minqold < 0.90
                    % --- PREPARE FLIP ---
                    if n1 == 1; tix11 = 2; tix12 = 3;
                    elseif n1 == 2; tix11 = 3; tix12 = 1;
                    else; tix11 = 1; tix12 = 2; end
                    
                    n2 = t2n(t1, n1);
                    
                    if n2 == 1; tix21 = 2; tix22 = 3;
                    elseif n2 == 2; tix21 = 3; tix22 = 1;
                    else; tix21 = 1; tix22 = 2; end
                    
                    % New Indices
                    % newt1 = t(t1,:); newt1(tix12) = t(t2, n2);
                    % newt2 = t(t2,:); newt2(tix22) = t(t1, n1);
                    
                    nt1_1 = ti1; nt1_2 = ti2; nt1_3 = ti3;
                    if tix12 == 1; nt1_1 = t(t2,n2);
                    elseif tix12 == 2; nt1_2 = t(t2,n2);
                    else; nt1_3 = t(t2,n2); end
                    
                    nt2_1 = tj1; nt2_2 = tj2; nt2_3 = tj3;
                    if tix22 == 1; nt2_1 = t(t1,n1);
                    elseif tix22 == 2; nt2_2 = t(t1,n1);
                    else; nt2_3 = t(t1,n1); end
                    
                    % ------------------------------------------------------------
                    % --- COMPUTE NEW QUALITY (Q3, Q4) ---
                    % ------------------------------------------------------------
                    
                    % New T1
                    nx1_ = px(nt1_1); ny1_ = py(nt1_1); nz1_ = pz(nt1_1);
                    nx2_ = px(nt1_2); ny2_ = py(nt1_2); nz2_ = pz(nt1_2);
                    nx3_ = px(nt1_3); ny3_ = py(nt1_3); nz3_ = pz(nt1_3);
                    
                    dxa = nx2_-nx1_; dya = ny2_-ny1_; dza = nz2_-nz1_;
                    dxb = nx3_-nx1_; dyb = ny3_-ny1_; dzb = nz3_-nz1_;
                    
                    % Cross Product New T1 (store for normal check)
                    cx3 = dya*dzb - dza*dyb;
                    cy3 = dza*dxb - dxa*dzb;
                    cz3 = dxa*dyb - dya*dxb;
                    
                    nsq3 = cx3*cx3 + cy3*cy3 + cz3*cz3;
                    vol3 = sqrt(nsq3);
                    
                    dxc = nx3_-nx2_; dyc = ny3_-ny2_; dzc = nz3_-nz2_;
                    den3 = (dxa*dxa + dya*dya + dza*dza) + ...
                           (dxb*dxb + dyb*dyb + dzb*dzb) + ...
                           (dxc*dxc + dyc*dyc + dzc*dzc);
                    
                    q3 = (C_QUAL * 0.5 * vol3) / den3;
                    
                    % New T2
                    mx1_ = px(nt2_1); my1_ = py(nt2_1); mz1_ = pz(nt2_1);
                    mx2_ = px(nt2_2); my2_ = py(nt2_2); mz2_ = pz(nt2_2);
                    mx3_ = px(nt2_3); my3_ = py(nt2_3); mz3_ = pz(nt2_3);
                    
                    dxm = mx2_-mx1_; dym = my2_-my1_; dzm = mz2_-mz1_;
                    dxn = mx3_-mx1_; dyn = my3_-my1_; dzn = mz3_-mz1_;
                    
                    % Cross Product New T2
                    cx4 = dym*dzn - dzm*dyn;
                    cy4 = dzm*dxn - dxm*dzn;
                    cz4 = dxm*dyn - dym*dxn;
                    
                    nsq4 = cx4*cx4 + cy4*cy4 + cz4*cz4;
                    vol4 = sqrt(nsq4);
                    
                    dxo = mx3_-mx2_; dyo = my3_-my2_; dzo = mz3_-mz2_;
                    den4 = (dxm*dxm + dym*dym + dzm*dzm) + ...
                           (dxn*dxn + dyn*dyn + dzn*dzn) + ...
                           (dxo*dxo + dyo*dyo + dzo*dzo);

                    q4 = (C_QUAL * 0.5 * vol4) / den4;
                    
                    % ------------------------------------------------------------
                    % --- CHECK IMPROVEMENT ---
                    minqnew = min(q3, q4);
                    if minqnew > minqold + 0.025
                        % --- CHECK NORMALS ---
                        % Note: n1,n2,c3,c4 unnormalized, OK since only check > 0
                        dot_old = nx1*nx2 + ny1*ny2 + nz1*nz2;
                        dot_new = cx3*cx4 + cy3*cy4 + cz3*cz4;
                        if (dot_old > 0) && (dot_new > 0)
                            % --- FLIP IS VALID: UPDATE TOPOLOGY ---
                            
                            % Update t
                            t(t1,1) = nt1_1; t(t1,2) = nt1_2; t(t1,3) = nt1_3;
                            t(t2,1) = nt2_1; t(t2,2) = nt2_2; t(t2,3) = nt2_3;
                            
                            % Update t2t/t2n
                            nbt = t2t(t2, tix21);
                            nbn = t2n(t2, tix21);
                            
                            t2t(t1, n1) = nbt;
                            t2n(t1, n1) = nbn;
                            
                            if nbt > 0
                                t2t(nbt, nbn) = t1;
                                t2n(nbt, nbn) = n1;
                            end
                            
                            nbt = t2t(t1, tix11);
                            nbn = t2n(t1, tix11);
                            
                            t2t(t2, n2) = nbt;
                            t2n(t2, n2) = nbn;
                            
                            if nbt > 0
                                t2t(nbt, nbn) = t2;
                                t2n(nbt, nbn) = n2;
                            end
                            
                            t2t(t1, tix11) = t2;
                            t2n(t1, tix11) = tix21;
                            
                            t2t(t2, tix21) = t1;
                            t2n(t2, tix21) = tix11;
                        end
                    end
                end
            end
        end
    end
end
