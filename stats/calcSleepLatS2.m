function [sleepLat latDef] = calcSleepLat(stages)
% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 11/22/2010
%
% Calculates sleep latencey as the first epoch of stage2
%    
St2 = find(stages==2);

foundOnset = 0;
sleepLat = St2(1);

latDef = 'The time from the epoch of lights out until the first epoch of Stage 2.';
end
