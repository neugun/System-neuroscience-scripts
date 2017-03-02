%open NSx file, get the PowerSpectrum of selected channel and every
%interval selected channel PowerSpectrum.
openNSx;
fpath = NS2.MetaTags.FilePath;
fname = [NS2.MetaTags.Filename(1:end-4) '.nev'];
openNEV([fpath '\' fname]);
Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 100;                     % Length of signal(bin)
N = 4096;                    % number of frequence
LFP = double(NS2.Data(18,:)); %get data from channel 18 
Digitin = NEV.Data.SerialDigitalIO.TimeStampSec; % stimuli event timestamp

timestamps = fix(length(LFP)/L);   %spectrogram timesatamps
sptm = zeros(N/2+1,timestamps);
sptmlog = zeros(N/2+1,timestamps);
delta = zeros(1,timestamps);
theta = zeros(1,timestamps);
beta = zeros(1,timestamps);
gamma = zeros(1,timestamps);
mpfcdelta = zeros(1,timestamps);
mpfctheta = zeros(1,timestamps);
for i=1:timestamps
x = zeros(1,4096);
x(1,1:100) = LFP(1,100*(i-1)+1:100*i);
t = linspace(0,1,length(x));
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)).*abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
logdx = 10*log10(psdx);
freq = 0:Fs/length(x):Fs/2;
sptm(1:length(psdx),i) = reshape(psdx,length(psdx),1);% spectrugram in raw
sptmlog(1:length(logdx),i) = reshape(logdx,length(logdx),1);
delta(i) = mean(logdx(1,4:16)); %mean delta power 1-4hz
theta(i) = mean(logdx(1,17:40)); %mean theta power 4-10hz
beta(i) = mean(logdx(1,41:120));  %mean beta power 10-30hz
gamma(i) = mean(logdx(1,121:320)); %mean gamma power 30-80hz
mpfcdelta(i) = sum(psdx(1,12:16))/sum(psdx(1,1:end));
mpfctheta(i) = sum(psdx(1,24:30))/sum(psdx(1,1:end));
end
%plot(mpfcdelta);
%plot(mpfctheta);
%if fix(length(Digitin)/99) == length(Digitin)/99
    %stimulitimes = 99;
%else
   % stimulitimes =100;
%end
%stimulistart = Digitin(1:length(Digitin)/stimulitimes:end);
%stimulidura = 100; % duration 10s bin=0.1s 
%perisptm = zeros(N/2+1,300);
%for j = 1:stimulitimes
   % perisptm(1:length(logdx),1:300) = sptm(1:end,stimulistart(j)-100:stimulistart(j)+200);
