% Separate multichannel audio into mono tracks.
[file,location]=uigetfile('*.wav');
filefull = fullfile(location,file);
[p,f,e]=fileparts(filefull);

[Y,fs]=audioread(filefull);

tracknum=length(Y(1,:));

s=0;
for i=1:tracknum
    if i-s>=0
    trackname=strcat([f,'_ch',num2str(i),'.WAV']);
    audiowrite(trackname,Y(:,i),fs,'BitsPerSample',32);
    s=s+1;
    end
end
