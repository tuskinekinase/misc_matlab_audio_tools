%% Preset fs and other parameters
clear all,close all;
fs=44100;   %set sample frequency
ts = 1/fs;      %sample time unit
leng = 0.2; %set time length by second
t = 0:ts:leng-ts;   %time domain for frequency modulation
f1 = 1000;  %set
oct=1;  %set octaves
logspace = 0:oct/length(t):oct-oct/length(t); %create log sequence for FM time domain.
f = f1*2.^logspace;   %create FM frequency slide

%% Run waveform
% waveform = [];
waveform = sin(2*pi.*f.*t);

%% Plot Figure
plot(t,waveform,'LineWidth',1,'Color','b')

set(gcf,'Position',[300 300 600 200])
set(gca,'XLim',[0 leng])
set(gca,'XTick',0:leng:leng)
set(gca,'XTickLabel',{'0',num2str(leng)})
set(gca,'YLim',[-1 1])
ax = gca;
title([num2str(f1),'Hz octave sweep']);
ax.XLabel.String = 'Time (s)';
ax.YLabel.String = 'Relative amplitude';

%%  Plot FFT
Y = fft(waveform);
P2 = abs(Y/length(waveform));
P1 = P2(1:length(waveform)/2+1);
P1(2:end-1) = 2*P1(2:end-1);

ft = fs*(0:(length(waveform)/2))/length(waveform);
figure
plot(ft,P1) 
title('Single-Sided Amplitude Spectrum of FM signal')
xlabel('f (Hz)')
ylabel('|P1(f)|')
set(gca,'XLim',[0 20000])