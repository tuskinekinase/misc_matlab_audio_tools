% Quick consolidated code for any audio snippet
clear all,close all;
%% Load vocalization
[baseName, folder] = uigetfile({'*.wav'},...
                          'File Selector');
fullFileName = fullfile(folder, baseName);
filename = fullfile(folder, baseName);
[y,fs] = audioread(fullFileName);
ts = 1/fs;      %sample time unit
leng = length(y)/fs;        %objective time length by second
t = 0:ts:leng-ts;       %obsolete from FM program

%%  plot waveform
plot(t,y,'LineWidth',1,'Color','b')
set(gcf,'Position',[300 300 600 200])
set(gca,'XLim',[0 leng])
set(gca,'XTick',0:leng:leng)
set(gca,'XTickLabel',{'0',num2str(leng)})
ax = gca;
title('Audio Waveform');    %Change name
ax.XLabel.String = 'Time (s)';
ax.YLabel.String = 'Amplitude (V)';

%%  plot spectrogram
[s,f,t_sp]=specgram(y,[],fs);%s:freq x time   %%t is used for signal length, rename spectrogram time domain to t_sp
s=20*log10(abs(s)+eps);
figure(2)
imagesc(t_sp,f,s);axis xy;colormap('jet');colorbar;hold on

title("Audio Spectrogram");
xlabel('Time (s)');
ylabel('Frequency (Hz)');

%%  Plot FFT
Y = fft(y);
P2 = abs(Y/length(y));  %length=signal length=L in Mathworks tutorial code
P1 = P2(1:length(y)/2+1);
P1(2:end-1) = 2*P1(2:end-1);

ft = fs*(0:(length(y)/2))/length(y);
figure(3)
plot(ft,P1) 
title('Single-Sided Amplitude Spectrum of Vocalization')
xlabel('f (Hz)')
ylabel('|P1(f)|')
set(gca,'XLim',[0 20000])

%% Function
% [features] = extractFeatures(filename);
% 
% disp('Features (mean(F0) duration minFreq freqBandwidth timeToMinFreq timeToMaxFreq totalBandPower) =')
% disp(features)
