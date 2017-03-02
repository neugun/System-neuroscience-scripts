 
function remapNEVspike(fileFullPath, addedSuffix)

clear all
%% Setting the default for addedExtension
if ~exist('addedSuffix', 'var')
    addedSuffix = 'remap';
end


%% Opening the file and reading header
if ~exist('fileFullPath', 'var')
    [dataFilename dataFolder] = getFile('*.nev');
    fileFullPath = [dataFolder dataFilename];
end
FID = fopen(fileFullPath, 'r', 'ieee-le');



%% Calculating the header bytes
BasicHeader = fread(FID, 20, '*uint8');
headerBytes  = double(typecast(BasicHeader(13:16), 'uint32'));
dataPacketByteLength = double(typecast(BasicHeader(17:20), 'uint32'));

%% Calculating the data file length and eeking to the beginning of the file
fseek(FID, 0, 'eof');
endOfDataByte = ftell(FID);
dataByteLength = endOfDataByte - headerBytes;
numberOfPackets = double(dataByteLength) / double(dataPacketByteLength);

%% Reading the header binaries and saving it for future
fseek(FID, 0, 'bof');
headerBinaries = fread(FID, headerBytes, '*uint8');

%% Reading the data binaries
dataBinaries = fread(FID, [dataPacketByteLength numberOfPackets], '*uint8', 0);


%% Finding what PacketIDs have the desired channels
for IDX = 1:size(dataBinaries,2)
    PacketIDs(IDX) = typecast(dataBinaries(5:6, IDX), 'uint16');
end

 

for i=1:numberOfPackets
                                       %%%remap the channels to fits offline sorter.
    if mod(PacketIDs(i),8) == 2
        tetrode(i)= PacketIDs(i)+3;
    elseif mod(PacketIDs(i),8) == 3
            tetrode(i)= PacketIDs(i)-1;
                    elseif    mod(PacketIDs(i),8) == 4
                    tetrode(i)= PacketIDs(i)+2;
    elseif mod(PacketIDs(i),8) == 5                              %  basic rule: 1,3,5,7--1,2,3,4
             tetrode(i)= PacketIDs(i)-2;
    elseif mod(PacketIDs(i),8) == 6
        tetrode(i)= PacketIDs(i)+1;
        elseif mod(PacketIDs(i),8) == 7
           tetrode(i)= PacketIDs(i)-3;
            else
               tetrode(i)= PacketIDs(i);
      
end
end

dataBinaries(5,:) = tetrode;



%% Determining the file name
currentFileNames = dir([fileFullPath(1:end-4) '-' addedSuffix '*.nev']);
if ~isempty(currentFileNames)
    fileIDX = str2num(currentFileNames(end).name(end-6:end-4))+1;
else
    fileIDX = 1;
end

%% Saving the new NEV containig the desired channels
FIDw = fopen([fileFullPath(1:end-4) '-' addedSuffix sprintf('%03d', fileIDX) fileFullPath(end-3:end)], 'w+', 'n');
fwrite(FIDw, headerBinaries, 'uint8');
fwrite(FIDw, dataBinaries, 'uint8');
fclose(FID);
fclose(FIDw);