% Code for finding smoothed F0 of audio data
clear all;

%% Load vocalization
% [Y,fs] = audioread('voc_twit_S8_arena_Ch2_1097.wav');
[baseName, folder] = uigetfile({'*.wav'},...
                          'File Selector');
fullFileName = fullfile(folder, baseName);
[Y,fs] = audioread(fullFileName);
leng=length(Y)/fs;

%% Find f0 because we don't have audio toolbox :(
[s,ff,t_sp]=specgram(Y,[],fs);%s:freq x time   %%t is used for signal length, rename spectrogram time domain to t_sp
s=20*log10(abs(s)+eps);
figure(1)
imagesc(t_sp,ff,s);axis xy;colormap('jet');colorbar;hold on

ff_ind=(min(find(ff>=5000)):max(find(ff<=11000)));
for i=1:length(t_sp)
    [max_num,max_idx] = max(s(ff_ind,i));
    val(i) = max(s(ff_ind,i));
    f0_temp(i) = ff(max_idx+min(ff_ind));
end

val_sm = smoothdata(val,'gaussian',25);
% plot(val_sm);
f0_sm = smoothdata(f0_temp,'gaussian',25);
% figure
% plot(f0_sm);

ind = find(val_sm>=-50);

t0 = t_sp(1:length(ind));
f0 = f0_sm(ind);

figure(2)
plot(t0,f0_temp(ind));
hold on;
plot(t0,f0);

%%  polyfit
p = polyfit(t0,f0,5);
y1 = polyval(p,t0);

plot(t0,y1);

fprintf('p = ');
disp(p);