function [cycleBounds, NREMsegments, REMsegments] = getNREMcyc(sleep, win)
% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 11/22/2010
%
% cycleBounds = getNREMcyc(sleep, win)
%
% Inputs:
% sleep = sleep data starting with the onset of sleep and ending with the
% epoch before the final awakening (i.e. SPT)
% win = the number of seconds in an epoch
%
% Outputs:
% cycleBounds = an nX3 matrix with n bing the number os cycles.  the first
% entry in a row is the start of the NREM cycle the second is the start of
% the REM period and the last is the end of the cycle.
%

%% prameters
REMcombTime = 15;
REMmin = 5; %this minimum does not apply to the first of last REM period
startStage = 2; %start with stage 2 or greater (as long as it's not REM)


%% get cycles
REMsegments = [];
sleepSt = find((sleep >= startStage) & (sleep < 5));
startCyc = sleepSt(1);

c = 1;
while(startCyc < length(sleep))
    if(c == 1)
        %no minimum REM length for the first cycle
        [stREM, endCyc] = getStartEnd(sleep(startCyc:end), win, 0, REMcombTime, startStage);
    else
        [stREM, endCyc] = getStartEnd(sleep(startCyc:end), win, REMmin, REMcombTime, startStage);
    end
    cycleBounds(c, 1) = startCyc;
    if(stREM > 0)
        cycleBounds(c, 2) = stREM + startCyc - 1;
    end 
    cycleBounds(c, 3) = endCyc + startCyc - 1;
    
    if(cycleBounds(c, 2) == 0)
        NREMsegments{c} = getNREMsegments(sleep(cycleBounds(c, 1):cycleBounds(c, 3))) + cycleBounds(c, 1) - 1;
    else
        REMsegments{c} = getREMsegments(sleep(cycleBounds(c, 2):cycleBounds(c, 3))) + cycleBounds(c, 2) - 1;
        NREMsegments{c} = getNREMsegments(sleep(cycleBounds(c, 1):cycleBounds(c, 2))) + cycleBounds(c, 1) - 1;
    end
    
    startCyc = endCyc + startCyc;
    c = c + 1;
end



%% helper functinos

function [stREM, endCyc] = getStartEnd(sleep, win, REMmin, REMcombTime, startStage)

    i = 0;
    c = 0;
    lastREM = length(sleep);
    stREM = 0;
    REMtime = 0;
    hitREM = false;
    
    while(i < length(sleep) && c < (REMcombTime*(60/win)))
        i = i + 1;
        if(sleep(i) == 5)
            if(~hitREM)
                %this is the index of the first REM
                stREM = i; 
            end
            hitREM = true;
            REMtime = REMtime + 1;
            lastREM = i;
            c = 0;
        elseif(hitREM)
            c = c + 1;
        end

        
        %checks to make sure the REM period is greater than 5 minutes
        if((c == REMcombTime*(60/win)) && REMtime < REMmin*(60/win))
            c = 0;
            hitREM = false;
            REMtime = 0;
            stREM = 0;
            lastREM = length(sleep);
        end
    end

    findSt = find((sleep(lastREM:end) >= startStage) & (sleep(lastREM:end) < 5));
    
    if(isempty(findSt) || (length(sleep(lastREM:end)) < REMcombTime*(60/win)))
        endCyc = length(sleep);
    else
        endCyc = lastREM + findSt(1) - 2;
    end
    
    
function segments = getREMsegments(curCycle)
    allRem = find(curCycle == 5);
    
    if(isempty(allRem))
        segments = [];
    elseif(length(allRem) == 1)
        segments(1, 1) = allRem(1);
        segments(1, 2) = allRem(1);
    else
        segments(1, 1) = allRem(1);
        c = 1;
        for i = 2:length(allRem)
            if(abs(allRem(i) - allRem(i - 1)) > 1)
                segments(c, 2) = allRem(i - 1);
                c = c + 1;
                segments(c, 1) = allRem(i);
            end
        end
        segments(c, 2) = allRem(end);
    end
    
    
 function segments = getNREMsegments(curCycle)
    allNRem = find(curCycle ~= 5);
    
    if(isempty(allNRem))
        segments = [];
    elseif(length(allNRem) == 1)
        segments(1, 1) = allNRem(1);
        segments(1, 2) = allNRem(1);
    else
        segments(1, 1) = allNRem(1);
        c = 1;
        for i = 2:length(allNRem)
            if(abs(allNRem(i) - allNRem(i - 1)) > 1)
                segments(c, 2) = allNRem(i - 1);
                c = c + 1;
                segments(c, 1) = allNRem(i);
            end
        end
        segments(c, 2) = allNRem(end);
    end
       
    
    