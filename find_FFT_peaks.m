%   Run after P1 (FFT) has been generated

%%  Preprocess
window = 10; %   Set gaussian window
[B, window] = smoothdata(log10(P1)*10,'gaussian');

%%  Set noise floor and peak threshold
noisefloor=mean(B);    %   Find noise floor
noisestd=std(B);       %   Find noise std
peak_thresh = noisefloor+1*noisestd;     %   Set threshold power (can be 1~3 std above)

%%  Search peak locations and values
[peak_value, peak_location] = findpeaks(log10(P1)*10,...
    'minpeakheight',noisefloor,...        %   can set minpeakheight to be anything if peak_thresh doesn't work
    'minpeakdistance',5,...
    'MinPeakProminence',35);         %   set minpeakprominence to filter out tiny peaks

peak_freqs = peak_location*ft(2);
peak_fft = P1(peak_location);

figure
plot(ft,log10(P1)*10,'b-');
hold on
plot(ft,B,'Color',[0.5 0.5 0.5]);
plot(peak_freqs,peak_value,'or')

%%  Display results
my_peak_freqs = sprintf('%16.f',peak_freqs)
my_peak_fftamps = sprintf('%16.6f',peak_fft)
my_peak_fftpows = sprintf('%16.2f',peak_value)