%% Preset fs and other parameters
clear all,close all;
[X,Fs] = audioread('phee.wav');
T = 1/Fs;
L = length(X);
t = (0:L-1)*T;

%%  Plot data
plot(1000*t(1:L),X(1:L))
title('Signal')
xlabel('t (milliseconds)')
ylabel('X(t)')

%%  FFT
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:(floor(L/2))+1);
P1(2:end-1) = 2*P1(2:end-1);
ft = Fs*(0:(L/2))/L;
subplot(2,1,1);
semilogy(ft,P1)     %   Plot with log scale
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
grid on

%%  Power spectrum
[P,F,T]=pspectrum(X,Fs);

subplot(2,1,2);
plot(F,log10(P)*10)  %Plot with log power (dB)
title('Power spectrum')
xlabel('f (Hz)')
ylabel('Power (dB)')
grid on
grid minor
