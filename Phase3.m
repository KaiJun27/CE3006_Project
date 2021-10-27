% Linear - OOK and BPSK
N = 1024;

data = randi([0,1], [1,N]);

fc = 10000; %carrier freq
dataRate = 1000;
fs = fc * 16; %sampling freq
encoded_bits=N*7/4;

%to start at where sampling interval starts
t_enc = 1/(2*fs):1/fs:encoded_bits/dataRate;
carrier_enc = cos(2*pi*fc*t_enc);
numSample = fs*N/dataRate*7/4;

% encoding
poly = cyclpoly(7,4);
parmat=cyclgen(7,poly);
genmat=gen2par(parmat);
encoded_data = encode(data, 7, 4, 'linear/binary', genmat);
extension_vector = ones(1, fs/dataRate);
encoded_data = kron(encoded_data, extension_vector);

OOK_mod_signal = OOK(encoded_data, carrier_enc);
BPSK_mod_signal = BPSK(encoded_data, carrier_enc);

dBSNR = zeros(1,11,'double');
linear_OOK_error = zeros(1,11,'double');
linear_BPSK_error = zeros(1,11,'double');

for i = 1:11
    dBSNR(i) = (i-1)*5;
    noiseData = noise(numSample, dBSNR(i));
    OOK_rx = signalAdd(OOK_mod_signal, noiseData);
    BPSK_rx = signalAdd(BPSK_mod_signal, noiseData);
    OOK_demod_data = demod_phase3(OOK_rx, encoded_bits, fs, dataRate, carrier_enc);
    BPSK_demod_data = demod_phase3(BPSK_rx, encoded_bits, fs, dataRate, carrier_enc);

    OOK_demod_data = decode(OOK_demod_data,7,4,'linear/binary',genmat);
    BPSK_demod_data = decode(BPSK_demod_data,7,4,'linear/binary',genmat);
    linear_OOK_error(i) = checkBitErrorRate(OOK_demod_data, data);
    linear_BPSK_error(i) = checkBitErrorRate(BPSK_demod_data, data);
end

hold on
title("SNR vs ErrorRate")
xlabel("dBSNR");
ylabel("errorRate");
semilogy(dBSNR, linear_OOK_error)
semilogy(dBSNR, linear_BPSK_error)
hold off
legend('linear_OOK','linear_BPSK');


% -------------------------------------------
% Hamming - OOK and BPSK
N = 1024;

data = randi([0,1], [1,N]);

fc = 10000; %carrier freq
dataRate = 1000;
fs = fc * 16; %sampling freq
encoded_bits=N*7/4;

%to start at where sampling interval starts
t_enc = 1/(2*fs):1/fs:encoded_bits/dataRate;
carrier_enc = cos(2*pi*fc*t_enc);
numSample = fs*N/dataRate*7/4;

% encoding
encoded_data = encode(data, 7, 4, 'hamming/binary');
extension_vector = ones(1, fs/dataRate);
encoded_data = kron(encoded_data, extension_vector);

OOK_mod_signal = OOK(encoded_data, carrier_enc);
BPSK_mod_signal = BPSK(encoded_data, carrier_enc);

dBSNR = zeros(1,11,'double');
hamming_OOK_error = zeros(1,11,'double');
hamming_BPSK_error = zeros(1,11,'double');

for i = 1:11
    dBSNR(i) = (i-1)*5;
    noiseData = noise(numSample, dBSNR(i));
    OOK_rx = signalAdd(OOK_mod_signal, noiseData);
    BPSK_rx = signalAdd(BPSK_mod_signal, noiseData);
    OOK_demod_data = demod_phase3(OOK_rx, encoded_bits, fs, dataRate, carrier_enc);
    BPSK_demod_data = demod_phase3(BPSK_rx, encoded_bits, fs, dataRate, carrier_enc);

    OOK_demod_data = decode(OOK_demod_data,7,4,'hamming/binary');
    BPSK_demod_data = decode(BPSK_demod_data,7,4,'hamming/binary');
    hamming_OOK_error(i) = checkBitErrorRate(OOK_demod_data, data);
    hamming_BPSK_error(i) = checkBitErrorRate(BPSK_demod_data, data);
end

hold on
title("SNR vs ErrorRate")
xlabel("dBSNR");
ylabel("errorRate");
semilogy(dBSNR, hamming_OOK_error)
semilogy(dBSNR, hamming_BPSK_error)
hold off
legend('hamming_OOK','hamming_BPSK');


% -------------------------------------------
% Cyclic - OOK and BPSK
N = 1024;

data = randi([0,1], [1,N]);

fc = 10000; %carrier freq
dataRate = 1000;
fs = fc * 16; %sampling freq
encoded_bits=N*7/4;

%to start at where sampling interval starts
t_enc = 1/(2*fs):1/fs:encoded_bits/dataRate;
carrier_enc = cos(2*pi*fc*t_enc);
numSample = fs*N/dataRate*7/4;

% encoding
poly = cyclpoly(7,4);
parmat=cyclgen(7,poly);
genmat=syndtable(parmat);
encoded_data = encode(data, 7, 4, 'cyclic/binary', poly);
extension_vector = ones(1, fs/dataRate);
encoded_data = kron(encoded_data, extension_vector);

OOK_mod_signal = OOK(encoded_data, carrier_enc);
BPSK_mod_signal = BPSK(encoded_data, carrier_enc);

dBSNR = zeros(1,11,'double');
cyclic_OOK_error = zeros(1,11,'double');
cyclic_BPSK_error = zeros(1,11,'double');

for i = 1:11
    dBSNR(i) = (i-1)*5;
    noiseData = noise(numSample, dBSNR(i));
    OOK_rx = signalAdd(OOK_mod_signal, noiseData);
    BPSK_rx = signalAdd(BPSK_mod_signal, noiseData);
    OOK_demod_data = demod_phase3(OOK_rx, encoded_bits, fs, dataRate, carrier_enc);
    BPSK_demod_data = demod_phase3(BPSK_rx, encoded_bits, fs, dataRate, carrier_enc);

    OOK_demod_data = decode(OOK_demod_data,7,4,'cyclic/binary',  poly, genmat);
    BPSK_demod_data = decode(BPSK_demod_data,7,4,'cyclic/binary', poly, genmat);
    cyclic_OOK_error(i) = checkBitErrorRate(OOK_demod_data, data);
    cyclic_BPSK_error(i) = checkBitErrorRate(BPSK_demod_data, data);
end

hold on
title("SNR vs ErrorRate")
xlabel("dBSNR");
ylabel("errorRate");
semilogy(dBSNR, linear_OOK_error)
semilogy(dBSNR, linear_BPSK_error)
semilogy(dBSNR, hamming_OOK_error)
semilogy(dBSNR, hamming_BPSK_error)
semilogy(dBSNR, cyclic_OOK_error)
semilogy(dBSNR, cyclic_BPSK_error)
hold off
legend('linear OOK error',  'linear BPSK error', 'hamming OOK error', 'hamming BPSK error', 'cyclic OOK','cyclic BPSK');
clear all;
