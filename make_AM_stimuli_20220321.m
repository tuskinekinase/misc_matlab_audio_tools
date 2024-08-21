%   Makes simple 100% depth SAM stimuli with 5ms cosine envelope
%% Preset fs and other parameters
clear all,close all;
fs = 97600;
ts = 1/fs;
leng = 0.2;
t = 0:ts:leng-ts;
f1 = 5000;
f2 = 33;

%%  Make 5ms length cosine envelopes
win = round(0.01/ts);   %   make both sides
win_freq = fs/win;
cos_win = cos(2*pi*win_freq*t(1:win))/2+0.5;
pad_ones = [];
pad_ones(1:length(t)-win)=1;
cos_env = [cos_win(floor(win/2)+1:win) pad_ones cos_win(1:floor(win/2))];

%% Run waveform
wave_car = sin(2*pi*f1*t);
wave_mod = abs(cos(2*pi*f2*t)-1)/2;
waveform = [];
for i=1:length(t)
    waveform(i) = wave_car(i)*wave_mod(i)*cos_env(i);
end

%Waveform plot
subplot (3,1,1);
plot(t,waveform,'LineWidth',1,'Color','b');
set(gcf,'Position',[300 100 600 600])
set(gca,'XLim',[0 leng])
set(gca,'XTick',0:leng:leng)
set(gca,'XTickLabel',{'0',num2str(leng)})
set(gca,'YLim',[-1 1])
ax = gca;
title([num2str(f1),'Hz carrier with ',num2str(f2),'Hz modulation']);
ax.XLabel.String = 'Time (s)';
ax.YLabel.String = 'Relative amplitude';

% mod shape plot
subplot (3,1,2);
plot(t,wave_mod,'LineWidth',1,'Color','k')
set(gca,'XLim',[0 leng])
set(gca,'XTick',0:leng:leng)
set(gca,'XTickLabel',{'0',num2str(leng)})
set(gca,'YLim',[0 1])
ax = gca;
title([num2str(f1),'Hz carrier with ',num2str(f2),'Hz modulation']);
ax.XLabel.String = 'Time (s)';
ax.YLabel.String = 'Modulation Depth';

%%  Plot FFT
Y = fft(waveform);
P2 = abs(Y/length(t));
P1 = P2(1:length(t)/2+1);
P1(2:end-1) = 2*P1(2:end-1);

ft = fs*(0:(length(t)/2))/length(t);
subplot (3,1,3);
plot(ft,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
set(gca,'XLim',[0 20000])


%%  Audiowrite
audiowrite('NAM_stim.wav',waveform,fs);
