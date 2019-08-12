% Load all variables created during parfor loop and parse them for
% plotting.
function [d_it_tot, d2_it_tot, d3_it_tot, d4_it_tot] = loadall(simul_iter, snr_range)
d_it_tot = zeros(1,length(snr_range));
d2_it_tot = zeros(1,length(snr_range));
d3_it_tot = zeros(1,length(snr_range));
d4_it_tot = zeros(1,length(snr_range));
for it=1:simul_iter
    mat = load(sprintf('./data/testingoutput%d.mat',simul_iter));
    d_it = reshape(mat.d_it, 1, length(snr_range));
    d2_it = reshape(mat.d2_it, 1, length(snr_range));
    d3_it = reshape(mat.d3_it, 1, length(snr_range));
    d4_it = reshape(mat.d4_it, 1, length(snr_range));
    d_it_tot = d_it_tot + d_it;
    d2_it_tot = d2_it_tot + d2_it;
    d3_it_tot = d3_it_tot + d3_it;
    d4_it_tot = d4_it_tot + d4_it;
end
d_it_tot = d_it_tot/simul_iter;
d2_it_tot = d2_it_tot/simul_iter;
d3_it_tot = d3_it_tot/simul_iter;
d4_it_tot = d4_it_tot/simul_iter;
end