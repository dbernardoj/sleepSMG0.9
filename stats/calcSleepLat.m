function [sleepLat latDef] = calcSleepLat(stages)
% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 11/22/2010
%
% Calculates sleep latencey as the first epoch of the first 90 secs of
% continuous sleep.
%
sleep = find((stages > 0) & (stages < 6));

foundOnset = 0;
sleepLat = sleep(1);
count = 1;
epCount = 1;
while(~foundOnset && count < length(sleep))
    count = count + 1;
    if((sleep(count) - sleep(count - 1)) == 1)
        epCount = epCount + 1;
    else
        sleepLat = sleep(count);
        epCount = 1;
    end
    if(epCount == 3)
        foundOnset = 1;
    end
end

latDef = 'The time from the epoch of lights out until the first epoch of 3 contiguous epochs of sleep.';
