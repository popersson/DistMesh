rand('state',1); % Always the same results

fstats=@(p,t) fprintf('%d nodes, %d elements, min quality %.2f\n', ...
                      size(p,1),size(t,1),min(simpqual(p,t)));
