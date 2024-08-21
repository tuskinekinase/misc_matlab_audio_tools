[Y,fs]=audioread('C:\Users\emily\Documents\MATLAB\DeepSqueak_test\Tsinghua\KM\Multi\220813_001_0002.WAV');
audiowrite('220813_KM_0002_ch1.wav',Y(:,1),fs,'BitsPerSample',32);
audiowrite('220813_KM_0002_ch2.wav',Y(:,2),fs,'BitsPerSample',32);
audiowrite('220813_KM_0002_ch3.wav',Y(:,3),fs,'BitsPerSample',32);
% audiowrite('220810_TJ_0006_ch4.wav',Y(:,4),fs,'BitsPerSample',32);