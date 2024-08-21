%   Find pitch (F0)
[y,fs] = audioread('C:\Users\emily\Documents\MATLAB\UPennData\MarmoVocs\Colony\Phee\voc_twit_S8_arena_Ch1_815.wav');
% [y,fs] = audioread('C:\Users\emily\Documents\MATLAB\vocalization_figures\phee.wav');

%%  plot spectrogram
[s,f,t_sp]=specgram(y,[],fs);%s:freq x time   %%t is used for signal length, rename spectrogram time domain to t_sp
s=20*log10(abs(s)+eps);
imagesc(t_sp,f,s);axis xy;colormap('jet');hold on

%%  Find F0
peak_value = [];
peak_freq = [];
for i=1:length(t_sp)
    [peak_value(i), peak_freq(i)] = max(s(7:53,i)); %   Check f for indices of frequency windows.
     peak_freq(i) = peak_freq(i)+6;     %   correct lowpass index shift
end

figure(2)
plot (t_sp,peak_freq, 'b-');
hold;

%%  Add trim function here to trim away quiet parts
ind_start = find (peak_value>=-5, 1, 'first');
ind_end = find (peak_value>=-5, 1, 'last');

t_okind = t_sp(ind_start:ind_end);
peakfreq_ind = peak_freq(ind_start:ind_end);

%%  Fit F0
t_fit = t_okind-t_okind(1);     %otherwise polynomial equation would not start from 0!
p = polyfit(t_fit, peakfreq_ind,5);     %   Fit F0 to a polynomial function

fit_freq = p(1)*t_fit.^5+p(2)*t_fit.^4+p(3)*t_fit.^3+p(4)*t_fit.^2+p(5)*t_fit+p(6);  %   plot polyfit function

plot(t_okind,fit_freq,'r--');  %compare polyfit result with original F0 plot

trim_length = t_sp(ind_end)-t_sp(ind_start)     %for reconstruction purpose, get approximate sound length
