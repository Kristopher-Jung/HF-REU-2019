function data = rand_data_gen(PSK_order_power,nframes,numData,numSym,nTransmit)
    data = randi([0 2^PSK_order_power-1],nframes*numData,numSym,nTransmit);
end