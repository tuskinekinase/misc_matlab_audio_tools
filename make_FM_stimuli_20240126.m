%   Makes sliding faux trillphee stimuli modeled on real trillphee calls (use in tandem with make_f0_polyfit.m)
%   FM modulation core by Sarita Singh
%   https://gist.github.com/itssingh/403a7f6f1316c1490ad8b0579c3b7905#file-frequency_modulation-m
clear all,close all;

%%  Create Basics
Ac=1; %amplitude of carrier wave
fm=22.5; %frequency of message signal (Hz)
% fc=6000; %carrier frequency (Hz)
p=1.0e+06 *   [0.7248   -1.1769    0.7201   -0.2004    0.0249    0.0064]; %Polynomial fit of a real call
% p=7082.7; %Flat for Trill
% p=7491.9; %Flat for Trillphee
F=50000; %sampling frequency (Hz)
fs=F;
kf=250; %frequency sensitivity, default at 250Hz
mi=kf/fm; % modulation index
T=1/F;
leng = 0.5; % Call length, change in tandem with p based on marmoset call data·
t=0:T:leng;% time vector
l=length(t);
 
%%  1.Message signal
m1=sin(2*pi*fm*t);  %Unmodified sine wave fm
El=0.2;   %Envelope transition length (percentage), default at 0.2
Ec=0.5; %Envelope center (percentage), default at 0.5 (middle)
Ep1=round((Ec-El/2)*l); Ep2=round((Ec+El/2)*l);   %Transition point

% e=1-t*(1/max(t));
en=[];  %Create FM envelope for faux trillphee. Change this envelope accordingly. Use e=1 for stable FM
en(1:Ep1)=1;
en(Ep1+1:Ep2)=1-t(1:Ep2-Ep1)/(El*leng);
en(Ep2+1:l)=0;  %
m=m1.*en;   %m is the message signal; when changing message signal, modify function for m here

figure(1);
subplot(311); % plot at 1st position in a 3-by-1 grid 
plot(t,m); xlabel('t(sec)'); ylabel('m(t)');
title('Message signal Vs Time')
 
%  Spectrum of message signal
n=length(m); %length returns period of the message signal
M=fftshift(fft(m,n)); %zero-centered fast fourier transform
f=F*(-n/2:n/2-1)/n; %zero-centered frequency range
figure(2);subplot(311); 
plot(f,abs(M));xlabel('f(Hz)'); ylabel('M(f)');
title('Spectrum of Message signal');
 
%%  2.Carrier wave
fc= polyval(p,t);
c=Ac*sin(2*pi.*fc.*t);
figure(1); subplot(312);
plot(t,c); xlabel('t(sec'); ylabel('c(t)');
title('Carrier signal Vs Time');
 
%  Spectrum of carrier wave
N=length(c);
C=fftshift(fft(c,N));
f=F*[-N/2:N/2-1]/N;
figure(2); subplot(312);
plot(f,abs(C)); xlabel('f(Hz)'); ylabel('C(f)');
title('Spectrum of Carrier wave');
 
%%  3.FM modulated signal
x_fm=Ac*sin(2*pi.*fc.*t-(mi*en.*cos(2*pi*fm*t))); 
% x_fm=Ac*sin(2*pi*fc*t-(mi*cos(2*pi*fm*t))); 
% figure(1); subplot(313);
% plot(t,x_fm); xlabel('t(Sec)'); ylabel('x_f_m(t)');
% title('FM modulated signal Vs Time');
 
%   Spectrum of fm modulated signal
l=length(x_fm);
X_fm=fftshift(fft(x_fm,l));
f=F*[-l/2:l/2-1]/l;
figure(2); subplot(313);
plot(f,abs(X_fm)); xlabel('f(Hz)'); ylabel('X_f_m(f)');
title('Spectrum of FM modulated signal');

%%  Harmonic stacking
f1=1/500.*sin(2*pi.*(2*fc).*t-(2*mi*en.*cos(2*pi*fm*t))); 
waveform_temp=x_fm+f1;
% f2=1/10000.*sin(2*pi.*(3*fc).*t-(3*mi*en.*cos(2*pi*fm*t))); 
% waveform_temp=x_fm+f1+f2;

% waveform_temp=x_fm;  %If no harmonic stacking

waveform_temp=waveform_temp/max(waveform_temp); %Normalize
% waveform_temp=0.9999*waveform_temp; %Hard limit if needed

%%  Make 5ms length cosine envelopes at beginning and end
win = round(0.01/T);   %   make both sides
win_freq = 44100/win;
cos_win = cos(2*pi*win_freq*t(1:win))/2+0.5;
pad_ones = [];
pad_ones(1:length(t)-win)=1;
cos_env = [cos_win(floor(win/2)+1:win) pad_ones cos_win(1:floor(win/2))];

waveform = [];
waveform = zeros(1,length(t));
for i=1:length(t)
    waveform(i) = waveform_temp(i)*cos_env(i);
end

%   Move windowed waveform plot here
figure(1); subplot(313);
plot(t,waveform); xlabel('t(Sec)'); ylabel('x_f_m(t)');
title('FM modulated signal Vs Time');

%%  Plot spectrogram
[s,ff,t_sp]=specgram(waveform,[],fs);%s:freq x time   %%t is used for signal length, rename spectrogram time domain to t_sp
s=20*log10(abs(s)+eps);
figure(3)
subplot(2,1,1)
imagesc(t_sp,ff,s);axis xy;colormap('jet');colorbar;hold on
title("Stimuli Spectrogram");
xlabel('Time (s)');
ylabel('Frequency (Hz)');

subplot(2,1,2)
plot(ff,s(:,100));
title("Stimuli Spectrum");
xlabel('Frequency (Hz)');
xlim([0 22000]);
ylabel('Power (dB)');

%%  Audiowrite
disp('Reviewing audio figures...');
disp("Transition length="+100*El+"%");
disp("Transition center="+100*Ec+"%");
disp("Transition start="+100*(Ec-0.5*El)+"%");
disp("Mod freq="+fm+" Hz, Mod depth="+kf+" Hz");
oktemp=input('Proceed to export audio data? (1=Yes, 0=No) ');

if oktemp == 1
    stimfilename = ("FMstim_leng"+100*El+"_center"+100*Ec+"_modfreq"+fm+"_depth"+kf+".wav");
    audiowrite(stimfilename,waveform,fs);
end