%% Preset fs and other parameters
% clear all,close all;
fs = 97600;
ts = 1/fs;
leng = 0.2;
t = 0:ts:leng-ts;
f1 = 2000;
f2 = 128;

%% Run waveform
% wave_car = sin(2*pi*f1*t);
wave_car = randn(1,length(t))
wave_mod = abs(cos(2*pi*f2*t)-1)/2;
waveform = [];
for i=1:length(t)
    waveform(i) = wave_car(i)*wave_mod(i);
end

%% Plot Figure
% figure,plot(linspace(-1/(2*ts),1/(2*ts),Nfft),abs(fftshift(fft(waveform,Nfft)))
plot(t,waveform,'LineWidth',1,'Color','b')

set(gcf,'Position',[300 300 600 200])
set(gca,'XLim',[0 leng])
set(gca,'XTick',0:leng:leng)
set(gca,'XTickLabel',{'0',num2str(leng)})
set(gca,'YLim',[-1 1])
ax = gca;
title([num2str(f1),'Hz carrier with ',num2str(f2),'Hz modulation']);
ax.XLabel.String = 'Time (s)';
ax.YLabel.String = 'Relative amplitude';

%%  Plot FFT
Y = fft(waveform);
P2 = abs(Y/length(t));
P1 = P2(1:length(t)/2+1);
P1(2:end-1) = 2*P1(2:end-1);

ft = fs*(0:(length(t)/2))/length(t);
figure
plot(ft,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
set(gca,'XLim',[0 20000])