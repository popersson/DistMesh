function [t,t2t,t2n] = trisurfupd_ref(t, t2t, t2n, p)
%TRISURFUPD_REF

% Reference implementation - very slow (due to array allocations in the inner loops)
% Use this for readability, but the JIT optimized trisurfupd for performance.
    
    mod3x1 = [2,3,1];
    mod3x2 = [3,1,2];

    function n = trinormal3(p1, p2, p3)
        d12 = p2 - p1;
        d13 = p3 - p1;
        n = cross(d12, d13);
        n = n / norm(n);
    end

    function q = triqual3(p1, p2, p3)
        d12 = p2 - p1;
        d13 = p3 - p1;
        d23 = p3 - p2;
        n = cross(d12,d13);
        vol = norm(n) / 2.0;
        den = dot(d12,d12) + dot(d13,d13) + dot(d23,d23);
        q = 6.928203230275509 * vol / den;
    end

    nt = size(t,1);
    for t1 = 1:nt
        for n1 = 1:3
            t2 = t2t(t1,n1);
            if (t2 > 0)
                q1 = triqual3(p(t(t1,1),:), p(t(t1,2),:), p(t(t1,3),:));
                q2 = triqual3(p(t(t2,1),:), p(t(t2,2),:), p(t(t2,3),:));
                minqold = min(q1,q2);
                if minqold < 0.9
                    n2 = t2n(t1,n1);
                    tix11 = mod3x1(n1);
                    tix12 = mod3x2(n1);
                    tix21 = mod3x1(n2);
                    tix22 = mod3x2(n2);

                    newt1 = t(t1,:);
                    newt2 = t(t2,:);

                    % Swap edge
                    newt1(tix12) = newt2(n2);
                    newt2(tix22) = newt1(n1);

                    q3 = triqual3(p(newt1(1),:), p(newt1(2),:), p(newt1(3),:));
                    q4 = triqual3(p(newt2(1),:), p(newt2(2),:), p(newt2(3),:));
                    minqnew = min(q3,q4);

                    if minqnew > minqold + 0.025
                        normal1 = trinormal3(p(t(t1,1),:), p(t(t1,2),:), p(t(t1,3),:));
                        normal2 = trinormal3(p(t(t2,1),:), p(t(t2,2),:), p(t(t2,3),:));
                        normal3 = trinormal3(p(newt1(1),:), p(newt1(2),:), p(newt1(3),:));
                        normal4 = trinormal3(p(newt2(1),:), p(newt2(2),:), p(newt2(3),:));

                        flip = (dot(normal1, normal2)) > 0 & (dot(normal3, normal4) > 0);
                        
                        if flip
                            % Insert new triangles
                            t(t1,:) = newt1;
                            t(t2,:) = newt2;

                            % Update t2t and t2n
                            nbt = t2t(t2,tix21);
                            nbn = t2n(t2,tix21);
                            t2t(t1,n1) = nbt;
                            t2n(t1,n1) = nbn;

                            if nbt > 0
                                t2t(nbt,nbn) = t1;
                                t2n(nbt,nbn) = n1;
                            end

                            nbt = t2t(t1,tix11);
                            nbn = t2n(t1,tix11);
                            t2t(t2,n2) = nbt;
                            t2n(t2,n2) = nbn;
                            if nbt > 0
                                t2t(nbt,nbn) = t2;
                                t2n(nbt,nbn) = n2;
                            end

                            t2t(t1,tix11) = t2;
                            t2n(t1,tix11) = tix21;
                            t2t(t2,tix21) = t1;
                            t2n(t2,tix21) = tix11;
                        end
                    end
                end
            end
        end
    end
end
