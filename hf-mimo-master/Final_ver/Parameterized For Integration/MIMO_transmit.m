% simulate the transmission of signal Tx through the Watterson channel in a MIMO system
% parameters:
%   - Tx = modulated transmitted signal
%   - SNR = signal-to-noise ratio (Eb/N0)
%   - nTx = number of transmit antennas
%   - nRx  = number of receive antennas
%   - fd = max doppler shift
%   - sGauss = standard deviations for doppler components
%   - fGauss = normalized centered frequencies for doppler components
%   - gGauss = power gain of doppler component
%   - Rs = sample rate

%default call: MIMO_transmit(Tx, SNR, nTx, nRx, 1, 0.2, 0.1, -0.5, 0.4, 1.2, 0.25, 9600)
function [Rx, pathgains] = MIMO_transmit(Tx, SNR, nTx, nRx, fd, sGauss1, sGauss2, fGauss1, fGauss2, gGauss1, gGauss2, Rs)

    [chanComp1, chanComp2] = Watterson_channel(nTx, nRx, fd, sGauss1, sGauss2, fGauss1, fGauss2, Rs); 
    
    [Rx, pathgains] = Watterson_transmit(Tx, SNR, chanComp1, chanComp2, gGauss1, gGauss2); 
end