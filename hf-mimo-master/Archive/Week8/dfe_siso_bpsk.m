function [a_tilde_dfe] = dfe_siso_bpsk(rx,tx,nFwdTaps,nFdbkTaps,est_c_dfe,est_b_dfe)
    
    rx=transpose(rx);
    tx=transpose(tx);
    
    nTx=size(tx,1);
    
    
%     for i=1:nTx
%         %estimated_c_dfe=[estimated_c_dfe;0, 0.707+1j*0.707 zeros(1,nFwdTaps-2)];
%         estimated_b_dfe=[estimated_b_dfe;0, 0.707+1j*0.707, zeros(1,nFdbkTaps-2)];
%     end
% 
%     
    N=size(tx,2);
    
    a_tilde_dfe=(ones(1,N-(nFwdTaps-1)));
    
    for k=1:N-(nFwdTaps-1)
       
        y_k_dfe=rx(:,k:k+nFwdTaps-1);
        z_k_ff_dfe=transpose(est_c_dfe*(y_k_dfe)');
       if(k==1)
            a_tilde_k_dfe=[zeros(1,nFdbkTaps)];
        elseif k<=nFdbkTaps
            a_tilde_k_dfe=[zeros(1,k) a_tilde_dfe(1,1:nFdbkTaps-k)];
        else
            a_tilde_k_dfe=a_tilde_dfe(:,k-nFdbkTaps:k-1);
        end
        
        
        z_k_fb_dfe=transpose(est_b_dfe*(a_tilde_k_dfe)');
        z_k_dfe=z_k_ff_dfe-z_k_fb_dfe;
        for j=1:nTx
            if ((z_k_dfe(j))<0)
                a_tilde_dfe(j,k)=0;
            end
            
        end
        %e_k_dfe=transpose(tx(:,k)-z_k_dfe);
    end

end