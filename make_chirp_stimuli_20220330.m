%   Makes FM chirp stimuli with 5ms cosine envelope
%   Signal processing toolbox is needed
clear all,close all;

%%  Create Basics
Ac=1; %amplitude of carrier wave
fm=33; %frequency of message signal (Hz)
fs=44100; %sampling frequency (Hz)
F0=5000;
F1=10000
ts=1/fs;
leng = 0.4;
t=0:ts:leng;% time vector

%%	Make FM chirp
waveform_temp = chirp(t,F0,leng,F1);           % start from F0, use time vector t, end at time=T and frequency F1

%%  Make 5ms length cosine envelopes
win = round(0.01/ts);   %   make both sides
win_freq = 44100/win;
cos_win = cos(2*pi*win_freq*t(1:win))/2+0.5;
pad_ones = [];
pad_ones(1:length(t)-win)=1;
cos_env = [cos_win(floor(win/2)+1:win) pad_ones cos_win(1:floor(win/2))];

%%  Make waveform
waveform = [];
for i=1:length(t)
    waveform(i) = waveform_temp(i)*cos_env(i);
end

%%  Plot waveform
%Waveform plot
subplot (2,1,1);
plot([0 F0],[leng F1]);
set(gcf,'Position',[300 100 600 400])
ax = gca;
title(['FM Chirp frequency']);
ax.XLabel.String = 'Time (s)';
ax.YLabel.String = 'Frequency (Hz)';

subplot (2,1,2);
plot(t,waveform,'LineWidth',1,'Color','b');
set(gca,'XLim',[0 leng])
set(gca,'XTick',0:leng:leng)
set(gca,'XTickLabel',{'0',num2str(leng)})
set(gca,'YLim',[-1 1])
ax = gca;
title([num2str(F0),'Hz to ',num2str(F1),'Hz chirp']);
ax.XLabel.String = 'Time (s)';
ax.YLabel.String = 'Relative amplitude';

%%  Plot spectrogram
[s,ff,t_sp]=specgram(waveform,[],fs);%s:freq x time   %%t is used for signal length, rename spectrogram time domain to t_sp
s=20*log10(abs(s)+eps);
figure(2)
imagesc(t_sp,ff,s);axis xy;colormap('jet');hold on

%%  Audiowrite
audiowrite('chirp_stim.wav',waveform,fs);
