N = 1024;

% dBSNR = 0;
% errorRate = SNRToErrorRate(N,dBSNR);
SNR = zeros(1,10,'double');
error = zeros(1,10,'double');

% generate for SNR 0 to 50 with intervals of 5
for i = 1:11
    SNR(i) = (i-1)*5;
    error(i) = SNRToErrorRate(N,SNR(i));
end

plot(SNR, error)
title("SNR vs ErrorRate")
xlabel("dBSNR");
ylabel("errorRate");
grid on