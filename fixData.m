function EEGout = fixData(EEG, missingEpochs, winsize)
%% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 2011

%EEGout = fixData(EEG, missingEpochs)
%
% This function inserts 0's to fill sections of missing data in the EEG
% struct.

if(nargin < 3)
    winsize = 30;
end

blankEpoch = zeros(size(EEG.data, 1), winsize*EEG.srate);
missingEpochs = sort(missingEpochs) - 1;

newData = EEG.data;

for e = 1:length(missingEpochs)
   epochSt = (missingEpochs(e)*winsize*EEG.srate) + 1;
   newData = [newData(:, 1:(epochSt - 1)), blankEpoch, newData(:, epochSt:end)];
end


EEGout = EEG;
EEGout.data = newData;

EEGout.pnts = size(EEGout.data,2);

