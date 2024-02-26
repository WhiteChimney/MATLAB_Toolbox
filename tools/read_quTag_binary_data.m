clear;

filename = 'C:/Users/217-Entangle/Desktop/timestamps2.bin';

fileinfo = dir(filename);
filesize = fileinfo.bytes;
headerSize = 40;
eventNumber = (filesize - headerSize)/10

tic;

fileID = fopen(filename);
header = fread(fileID,headerSize,'uint8','ieee-le');
data = fread(fileID,[5,eventNumber],'uint16','ieee-le');
fclose(fileID);

timeStamps = data(1,:).*(2^0) + data(2,:).*(2^16) + data(3,:).*(2^32) + data(4,:).*(2^48);
channels = data(5,:);

toc;


timeStamps(1:3)
channels(1:3)


