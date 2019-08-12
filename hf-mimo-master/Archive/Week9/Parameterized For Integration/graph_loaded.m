function graph_loaded(simul_iter, snr_range, ttlSymbols, nTx, M)
[d_it_tot, d2_it_tot, d3_it_tot, d4_it_tot] = loadall(simul_iter, snr_range);
legend = ["ZF", "MLD", "MMSE", "GA"];
bers = [d_it_tot;d2_it_tot;d3_it_tot;d4_it_tot];
graphing(legend, snr_range, bers, ttlSymbols, nTx, M);
end