function stageStats = plotSleepStats(stageData, outname)
% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 11/22/2010
%
% stageStats = plotSleepStats(stageData, outname)
%
% Required Inputs:
% stageData - a scoring struct from sleepSMG scoring
%    must have the following fields:
%       stages - complete stage vector with the 7's appended to the beginning
%       win - your scoring window size in seconds
%       Notes - any string
%       lightsON - a datevec for lights on
%       lightsOFF - a datevec for lights off
%       recStart - a datevec for the record start
%       srate - sampling rate of the data (used for plotHypnogram)
%       stageTime - The start time in seconds of each epoch in the stages vector (it should start at 0) (used for plotHypnogram)
%
% Optional Inputs:
% outname - the name (String) that you want the output to be called
% [Default: stageStats]
%
% Matlab Outputs:
% stageStats - a struct with all the statistics calculated
% 
% File outputs:
% outname_stats.mat - the stageStats struct
% outname_stats.csv - a csv file of all the fields in stageStats
% outname.html - web page output of all the stats
% outname_hyp1.jpg - hyponogram of data (used by outname.html)
% outname_hyp2.jpg - hyponogram of data with SW sleep collapsed (used by outname.html)
% outname_SPdist.jpg - bar graph of sleep percentage distributions (used by outname.html)
% 
%

%% set up

if(nargin < 2)
    outname = 'stageStats';
end

if(ischar(stageData))
    load(stageData);
end

stages = stageData.stages(stageData.stages ~= 7);
%onsets = stageData.onsets;
win = stageData.win;

csvwrite('stages.txt', stages)

stageMap = {'Wake'; 'Stage 1'; 'Stage 2'; 'Stage 3'; 'Stage 4'; 'REM'; 'MT'; 'None'};

report = '<html>';

report = [report, sprintf('<h1>*** Sleep Stats ***</h1>\n')];
for n = 1:size(stageData.Notes, 1)
    report = [report, sprintf('%s<br>', sprintf(stageData.Notes(n, :)))];
end
report = [report, sprintf('Scoring window: %d secs<br>\n', win)];

report = [report, sprintf('<br><b>Lights OUT: %s</b><br>\n', datestr(stageData.lightsOFF, 'HH:MM:SS.FFF'))];
stageStats.lightsOUT = datestr(stageData.lightsOFF, 'HH:MM:SS.FFF');
report = [report, sprintf('<b>Lights ON: %s</b><br>\n', datestr(stageData.lightsON, 'HH:MM:SS.FFF'))];
stageStats.lightsON = datestr(stageData.lightsON, 'HH:MM:SS.FFF');

%% Cal sleep latency
[sleepLat latDef] = calcSleepLat(stages);
allSleep = find(stages > 0 & stages < 6);
sleepEnd = allSleep(end);
allScored = find(stageData.stages < 7);
timeBeforeScore = allScored(1) - 1;
%%%%%%%%%%%%%

report = [report, sprintf('<br>Sleep onset epoch: %d (relative to record start: %d)<br>\n', sleepLat, sleepLat + timeBeforeScore)];
report = [report, sprintf('Final awakening epoch: %d (relative to record start: %d)<br>\n', sleepEnd, sleepEnd + timeBeforeScore)];
report = [report, sprintf('First scored epoch relative to record start: %d<br><br>\n', timeBeforeScore + 1)];
stageStats.milestones = [sleepLat (sleepLat+timeBeforeScore); sleepEnd, (sleepEnd+timeBeforeScore);(timeBeforeScore+1) NaN];

%% calc last stage
tmp = stages(stages > 0);
lastStage = tmp(end);
report = [report, sprintf('<b>Last stage of sleep: %s</b><br>\n', stageMap{lastStage + 1})];
stageStats.lastStageSleep = stageMap{lastStage + 1};

onT = floor((etime(datevec(stageData.lightsON), datevec(stageData.recStart)))/win);
%% calc awake at lights on
if(stageData.stages(onT) == 0)
    awakeP = 'Yes';
elseif(stageData.stages(onT) ~=7)
    awakeP = 'No';
else
    awakeP = 'Unscored';
end
report = [report, sprintf('<b>Awake at lights on? %s</b><br>\n', awakeP)];
stageStats.awakeLightsOn = awakeP;

%% Sleep percentages table %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

report = [report, '<td><h2>Sleep Percentages</h2></td>'];
report = [report, '<table><tr><td>'];
report = [report, sprintf('<table cellpadding="5">\n<tr><td></td><td>Epochs</td><td>Minutes</td><td>%%TDT</td><td>%%SPT</td><td>%%TST</td></tr>\n')];

TDTepoch = sum(stages < 7);
report = [report, sprintf('<tr><td><b>Total dark time:</b></td><td>%d</td><td>%.1f</td></tr>\n', TDTepoch, (TDTepoch*win)/60)];
stageStats.percentSleep(1, :) = [TDTepoch, (TDTepoch*win)/60, NaN, NaN, NaN];

SPTepoch = sum(stages(sleepLat:sleepEnd) < 7);
report = [report, sprintf('<tr><td><b>Sleep period time:</b></td><td>%d</td><td>%.1f</td><td>%.2f</td></tr>\n', SPTepoch, (SPTepoch*win)/60, SPTepoch/TDTepoch*100)];
stageStats.percentSleep(2, :) = [SPTepoch, (SPTepoch*win)/60, SPTepoch/TDTepoch, NaN, NaN];

TSTepoch = sum(stages(sleepLat:sleepEnd) > 0 & stages(sleepLat:sleepEnd) < 6);
report = [report, sprintf('<tr><td><b>Total sleep time:</b></td><td>%d</td><td>%.1f</td><td>%.2f</td><td>%.2f</td></tr>\n', TSTepoch, (TSTepoch*win)/60, TSTepoch/TDTepoch*100, TSTepoch/SPTepoch*100)];
stageStats.percentSleep(3, :) = [TSTepoch, (TSTepoch*win)/60, TSTepoch/TDTepoch, TSTepoch/SPTepoch, NaN];

SBSO = sum(stages(1:sleepLat) > 0 & stages(1:sleepLat) < 7);
report = [report, sprintf('<tr><td><b>Sleep before sleep onset:</b></td><td>%d</td><td>%.1f</td><td>%.2f</td></tr>\n', SBSO, (SBSO*win)/60, SBSO/TDTepoch*100)];
stageStats.percentSleep(4, :) = [SBSO, (SBSO*win)/60, SBSO/TDTepoch, NaN, NaN];

WASO = sum(stages(sleepLat:sleepEnd) == 0);
report = [report, sprintf('<tr><td><b>Wake after sleep onset:</b></td><td>%d</td><td>%.1f</td><td>%.2f</td><td>%.2f</td><td>%.2f</td></tr>\n', WASO, (WASO*win)/60, WASO/TDTepoch*100, WASO/SPTepoch*100, WASO/TSTepoch*100)];
stageStats.percentSleep(5, :) = [WASO, (WASO*win)/60, WASO/TDTepoch, WASO/SPTepoch, WASO/TSTepoch];

WAFA = sum(stages(sleepEnd:end) == 0);
report = [report, sprintf('<tr><td><b>Wake after final awakening:</b></td><td>%d</td><td>%.1f</td><td>%.2f</td><td>%.2f</td><td>%.2f</td></tr>\n', WAFA, (WAFA*win)/60, WAFA/TDTepoch*100, WAFA/SPTepoch*100, WAFA/TSTepoch*100)];
stageStats.percentSleep(6, :) = [WAFA, (WAFA*win)/60, WAFA/TDTepoch, WAFA/SPTepoch, WAFA/TSTepoch];

%%% Total wake time
cur = sum(stages == 0);
report = [report, sprintf('<tr><td><b>%s</b></td><td>%d</td><td>%.1f</td><td>%.2f</td><td>%.2f</td><td>%.2f</td></tr>\n', 'Total wake time', cur, (cur*win)/60, cur/TDTepoch*100, cur/SPTepoch*100, cur/TSTepoch*100)];
stageStats.percentSleep(7, :) = [cur, (cur*win)/60, cur/TDTepoch, cur/SPTepoch, cur/TSTepoch];

%%%% Percentages for each stage of sleep
for s = 1:6
    cur = sum(stages(sleepLat:sleepEnd) == s);
    report = [report, sprintf('<tr><td><b>%s</b></td><td>%d</td><td>%.1f</td><td>%.2f</td><td>%.2f</td><td>%.2f</td></tr>\n', stageMap{s + 1}, cur, (cur*win)/60, cur/TDTepoch*100, cur/SPTepoch*100, cur/TSTepoch*100)];
    stageStats.percentSleep(7 + s, :) = [cur, (cur*win)/60, cur/TDTepoch, cur/SPTepoch, cur/TSTepoch];
end

%%% NREM
cur = sum(stages(sleepLat:sleepEnd) > 0 & stages(sleepLat:sleepEnd) < 5);
report = [report, sprintf('<tr><td><b>%s</b></td><td>%d</td><td>%.1f</td><td>%.2f</td><td>%.2f</td><td>%.2f</td></tr>\n', 'NREM', cur, (cur*win)/60, cur/TDTepoch*100, cur/SPTepoch*100, cur/TSTepoch*100)];
stageStats.percentSleep(14, :) = [cur, (cur*win)/60, cur/TDTepoch, cur/SPTepoch, cur/TSTepoch];

%%% SW
cur = sum(stages(sleepLat:sleepEnd) > 2 & stages(sleepLat:sleepEnd) < 5);
report = [report, sprintf('<tr><td><b>%s</b></td><td>%d</td><td>%.1f</td><td>%.2f</td><td>%.2f</td><td>%.2f</td></tr>\n', 'SW', cur, (cur*win)/60, cur/TDTepoch*100, cur/SPTepoch*100, cur/TSTepoch*100)];
stageStats.percentSleep(15, :) = [cur, (cur*win)/60, cur/TDTepoch, cur/SPTepoch, cur/TSTepoch];


report = [report, '</table>'];

%% Sleep distributions chart

plotSleepDist(stageStats.percentSleep);
set(gcf, 'PaperPositionMode', 'auto');
saveas(gcf, [outname, '_SPdist.jpg'], 'jpg')
close(gcf);
report = [report, '</td><td>'];
report = [report, sprintf('<img src=''%s''>', [outname, '_SPdist.jpg'])]; 
report = [report, '</td></table>'];


%%   Latencies Table %%
%%%%%%%%%%%%%%%%%%%%%%%

report = [report, '<h2>Sleep Latencies</h2>'];
report = [report, sprintf('<table cellpadding="5">\n<tr><td></td><td>Epochs</td><td>Minutes</td></tr>\n')];

cur = sleepLat - 1;
report = [report, sprintf('<tr><td><b>lights out to %s</b></td><td>%d</td><td>%.1f</td></tr>\n', 'sleep onset', cur, (cur*win)/60)];
stageStats.SleepLat(1, :) = [cur, (cur*win)/60];

%%%% latencies form lights out for each
for s = 1:5
    all = find(stages == s);
    if(~isempty(all))
        cur = all(1) - 1;
    else
        cur = NaN;
    end
    report = [report, sprintf('<tr><td><b>lights out to %s</b></td><td>%d</td><td>%.1f</td></tr>\n', stageMap{s + 1}, cur, (cur*win)/60)];
    stageStats.SleepLat(s+ 1, :) = [cur, (cur*win)/60];
end

%%%% latencies from sleep onset for each
for s = 1:5
    all = find(stages(sleepLat:sleepEnd) == s);
    if(~isempty(all))
        cur = all(1) - 1;
    else
        cur = NaN;
    end
    report = [report, sprintf('<tr><td><b>Sleep onset to %s</b></td><td>%d</td><td>%.1f</td></tr>\n', stageMap{s + 1}, cur, (cur*win)/60)];
    stageStats.SleepLat(s+ 6, :) = [cur, (cur*win)/60];
end
report = [report, '</table>'];

%% Sleep splits - Quarters and thirds

report = [report, '<br><table cellpadding="5"><tr>'];
report = [report, '<td><h2>Quarters (min)</h2></td>'];
report = [report, '<td><h2>Thirds (min)</h2></td></tr>'];

%%%%%%%%%%%%%  get Quarters
report = [report, '<tr><td>'];
[report, stageStats, breaks] = sleepSplit(report, stageStats, stages(sleepLat:sleepEnd), stageMap, 4, win);
stageStats.quarterBounds = breaks + sleepLat - 1;
%%%%%%%%%%%%%  get Thirds
report = [report, '</td><td>'];
[report, stageStats, breaks] = sleepSplit(report, stageStats, stages(sleepLat:sleepEnd), stageMap, 3, win);
stageStats.thirdBounds = breaks + sleepLat - 1;
report = [report, '</td></tr></table>'];

%% Cycle stats

[cycleBounds, NREMsegs, REMsegs] = getNREMcyc(stages(sleepLat:sleepEnd), win);
cycleBounds(cycleBounds > 0) = cycleBounds(cycleBounds > 0) + sleepLat - 1;
stageStats.cycleBounds = cycleBounds;
for i = 1:length(NREMsegs)
    stageStats.NREMsegs{i} = NREMsegs{i} + sleepLat - 1;
end
for i = 1:length(REMsegs)
    stageStats.REMsegs{i} = REMsegs{i} + sleepLat - 1;
end
report = [report, '<table cellpadding="5"><tr><td>'];
report = [report, '<h2>NREM-REM Cycle Stats (min)</h2>'];
[report, stageStats, dataOut] = makeSectionStats(report, stageStats, stages, stageMap, cycleBounds(cycleBounds(:, 2) > 0, [1, 3]), win);
report = [report, '<tr><td>.</td></tr></table>'];
report = [report, '</td><td>'];
stageStats.CycleStats = dataOut;

%%%%%%%%%%%%%%%% NREM Period
report = [report, '<h2>NREM Period Stats (min)</h2>'];
endNREMper = cycleBounds(:, 2) - 1;
if(endNREMper(end) == -1)
    endNREMper(end) = cycleBounds(end, 3);
end
[report, stageStats, dataOut] = makeSectionStats(report, stageStats, stages, stageMap, [cycleBounds(:, 1), endNREMper], win);
report = [report, '<tr><td><b>Segments:</b></td>'];
lastRow = length(dataOut) + 1;
for c = 1:length(NREMsegs)
    report = [report, sprintf('<td>%d</td>', size(NREMsegs{c}, 1))];
    dataOut(lastRow, c) = size(NREMsegs{c}, 1);
end
report = [report, '</tr></table>'];
report = [report, '</td><td>'];
stageStats.NREMperiodStats = dataOut;

%%%%%%%%%%%%%%%% REM Period
report = [report, '<h2>REM Period Stats (min)</h2>'];
[report, stageStats, dataOut] = makeSectionStats(report, stageStats, stages, stageMap, cycleBounds(cycleBounds(:, 2) > 0, [2, 3]), win);
report = [report, '<tr><td><b>Segments:</b></td>'];
lastRow = length(dataOut) + 1;
for c = 1:length(REMsegs)
    report = [report, sprintf('<td>%d</td>', size(REMsegs{c}, 1))];
    dataOut(lastRow, c) = size(REMsegs{c}, 1);
end
report = [report, '</tr></table>'];
report = [report, '</td></table>'];
stageStats.REMperiodStats = dataOut;


% Edited by Jared, 11/5/10, exports: #Cycles, #Periods, Mean #Segments/Cycle, Stdev #Segments/Cycle
if(~isempty(stageStats.REMperiodStats))
    stageStats.CycleSummary = [size(stageStats.CycleStats,2) length(REMsegs) mean(stageStats.REMperiodStats(end, :)) std(stageStats.REMperiodStats(end,:))];
else
    stageStats.CycleSummary = [size(stageStats.CycleStats,2) length(REMsegs) NaN NaN];
end
%% REM summary

allREM = find(stages == 5);
allSleep = find(stages > 0 & stages < 7);
allScored = find(stages < 7);

if(~isempty(allREM))
    REMtoLsleep = (allSleep(end) - allREM(end))*win/60;
    REMtoLon = (allScored(end) - allREM(end))*win/60;
else
    REMtoLsleep = NaN;
    REMtoLon = NaN;

end

report = [report, sprintf('<br><b>Last REM to final awakening: %.1f</b><br>\n', REMtoLsleep)];
stageStats.REMtoLsleep = REMtoLsleep;

report = [report, sprintf('<b>Last REM to lights on: %.1f</b><br>\n', REMtoLon)];
stageStats.REMtoLon = REMtoLon;

%% REM dentisty

if(isfield(stageData, 'events'))
    if(isfield(stageData.events, 'REM'))
        [remStats, remReport] = getREMstats(stageData, stageStats, outname);
        stageStats.remStats = remStats;
        report = [report, remReport];
    end
end

%% Transition table

transTableAllStr = '<table cellpadding="5"><tr><td>From\To</td><td><b>Wake</b></td><td><b>Stage 1</b></td><td><b><b>Stage 2</b></td><td><b>Stage 3</b></td><td><b>Stage 4</b></td><td><b>REM</b></td><td><b>MT</b></td></tr>';
transTableAll = zeros(7, 7);
stagesOrig = stages(1:(end -1));
stagesLag = stages(2:end);

for t = 0:6
    transTableAllStr = [transTableAllStr, '<tr><td><b>', stageMap{t + 1}, ':</b></td>'];
    for t2 = 0:6
        transTableAll(t+1, t2+1) = sum(stagesOrig == t & stagesLag == t2);
        if(t == t2)
            transTableAllStr = [transTableAllStr, '<td><b>', num2str(transTableAll(t+1, t2+1)), '</b></td>'];
        else
            transTableAllStr = [transTableAllStr, '<td>', num2str(transTableAll(t+1, t2+1)), '</td>'];
        end
    end
    transTableAllStr = [transTableAllStr, '</tr>'];
end
transTableAllStr = [transTableAllStr, '</table>'];
stageStats.transTableAll = transTableAll;

transTableCollapseStr = '<table cellpadding="5"><tr><td>From\To</td><td><b>Wake</b></td><td><b>Stage 1</b></td><td><b><b>Stage 2</b></td><td><b>SW</b></td><td><b>REM</b></td><td><b>MT</b></td></tr>';
transTableCollapse = zeros(6, 6);
stagesOrig(stagesOrig == 4) = 3;
stagesLag(stagesLag == 4) = 3;

stageNums = [0, 1, 2, 3, 5, 6];
for t = 1:6
    if(t== 4)
        transTableCollapseStr = [transTableCollapseStr, '<tr><td><b>SW:</b></td>'];
    else
        transTableCollapseStr = [transTableCollapseStr, '<tr><td><b>', stageMap{stageNums(t) + 1}, ':</b></td>'];
    end
    for t2 = 1:6
        transTableCollapse(t, t2) = sum(stagesOrig == stageNums(t) & stagesLag == stageNums(t2)); 
        if(t == t2)
            transTableCollapseStr = [transTableCollapseStr, '<td><b>', num2str(transTableCollapse(t, t2)), '</b></td>'];
        else
            transTableCollapseStr = [transTableCollapseStr, '<td>', num2str(transTableCollapse(t, t2)), '</td>'];
        end
    end
    transTableCollapseStr = [transTableCollapseStr, '</tr>'];
end
transTableCollapseStr = [transTableCollapseStr, '</table>'];
stageStats.transTableCollapse = transTableCollapse;


%% write output

%writeStruct(stageStats, [outname, '_stats.csv'])
save([outname, '_stats.mat'], 'stageStats')
plotHypnogram(stageData, stageStats.cycleBounds);
set(gcf, 'PaperPositionMode', 'auto');
saveas(gcf, [outname, '_hyp1.jpg'], 'jpg')
close(gcf);
report = [report, sprintf('<h3>Full Hypnogram + TW events:</h3><img src=''%s''>', [outname, '_hyp1.jpg'])]; 
report = [report, '<h3>Full Transition Table:</h3>', transTableAllStr];

stageDataSW = stageData;
stageDataSW.stages(stageDataSW.stages == 4) = 3;
plotHypnogram(stageDataSW, stageStats.cycleBounds);
set(gcf, 'PaperPositionMode', 'auto');
saveas(gcf, [outname, '_hyp2.jpg'], 'jpg')
close(gcf);
report = [report, sprintf('<h3>SW Collapsed Hypnogram + TW events:</h3><img src=''%s''>', [outname, '_hyp2.jpg'])]; 
report = [report, '<h3>SW Collapsed Transition Table:</h3>', transTableCollapseStr];

%% report definitions

report = [report, '<br><br><br><b>Sleep Statistics Definitions and Explanations:</b><p>', ...
'<b>SPT:</b> sleep period time (elapsed time from sleep onset through last epoch of sleep).<br>', ...
'<b>TDT:</b> Total dark time (elapsed time from lights out to lights on).<br>', ...
'<b>TST:</b> Total sleep time (duration of time spent in Stages 1, 2, 3, 4 and REM during SPT).<br>', ...
'<b>NREM:</b> Duration of time in Stages 1, 2, 3, 4.<br> ', ...
'<b>SW:</b> Slow wave sleep (Stages 3, 4). <br>', ...
'<b>All sleep tabulated from within SPT.</b><br> '];
report = [report,sprintf('<b>Sleep Onset:</b> %s<br>\n',latDef)];
report = [report, '<b>Wake After Sleep Onset:</b> Wake time after sleep onset during SPT.<br> ', ...
'<b>Wake After Final Awakening:</b> Elapsed time spent awake between the final epoch of sleep and lights on. <br>', ...
'<b>Sleep Before Sleep Onset:</b> Any transient sleep occurring between lights off and sleep onset.<br> ', ...
'<b>All Stage Latencies:</b> Elapsed time to first epoch of specified stage (from either lights off or sleep onset, as specified).<br>', ...
'<b>Quarters and Thirds:</b> Calculated from SPT. <br><br>', ...
'<b>NREM-REM Cycle definitions per the modified criterion of Feinberg and Flyod (1979) as in Aeschbach and Borb&eacute;ly (1993).</b><br><br>', ...
'<b>NREM-REM Cycle:</b> Succession of NREM period of at least 15 minutes duration by a REM period of at least 5 minutes duration.<br>', ...
'<b>No minimum duration for the first or last REM period.</b><br>', ...
'<b>NREM Period:</b> Time interval between first occurance of Stage 2 and the first epoch of the next REM period.<br>', ...
'<b>REM Period:</b> Time interval between two consecutive NREM periods  or the between the last NREM period and final awakening.<br>', ...
'<b>NREM/REM Segments:</b> Number of uninterrupted periods of NREM/REM during a NREM/REM period.<br><br>',...
'<b>All other sleep statistics per: <br><br>',...
'Carskadon, MA, Rechtschaffen, A. Monitoring and Staging Human Sleep. In: Principles and Practices of Sleep Medicine 4th Edition, pgs. 1359-1377. Ed: Kryger, MH, Roth, T, Dement, WC.  Philadelphia, PA : Elsevier Saunders, 2005.<br><br>',...
'</p>'];


fid = fopen([outname, '.html'], 'w');
fwrite(fid, report);



%% helper functions

function [report, stageStats, breaks] = sleepSplit(report, stageStats, stages, stageMap, splitter, win)

q = ceil(length(stages)/splitter);
for r = 1:splitter
    if(r*q < length(stages))
        breaks(r, :) = [((r-1)*q + 1), (r*q)];
    else
        breaks(r, :) = [((r-1)*q + 1), length(stages)];
    end
end

[report, stageStats, dataOut] = makeSectionStats(report, stageStats, stages, stageMap, breaks, win);
report = [report, '</table>'];
eval(['stageStats.split', num2str(splitter), '=dataOut;'])



function [report, stageStats, dataOut] = makeSectionStats(report, stageStats, stages, stageMap, breaks, win)
dataOut = [];
report = [report, '<table cellpadding="5"><tr><td></td>'];
for r = 1:size(breaks, 1)
    report = [report, sprintf('<td>%d</td>', r)];
end
report = [report, '</tr>'];

for s = 0:6
    report = [report, '<tr>'];
    for r = 1:size(breaks, 1)
        if(r == 1)
            report = [report, sprintf('<td><b>%s:</b></td>', stageMap{s + 1})];
        end
        curData = find(stages(breaks(r, 1):breaks(r, 2)) == s);
        if(~isempty(curData))
            report = [report, sprintf('<td>%.2f</td>',((length(curData))*win)/60)];
        else
            report = [report, sprintf('<td>-</td>')];
        end
        dataOut(s + 1, r) = ((length(curData))*win)/60;
    end
    report = [report, sprintf('</tr>\n')];
end
for r = 1:size(breaks, 1)
    if(r == 1)
        report = [report, sprintf('<tr><td><b>%s:</b></td>', 'SW')];
    end
    curData = find(stages(breaks(r, 1):breaks(r, 2)) == 3 | stages(breaks(r, 1):breaks(r, 2)) == 4);
    if(~isempty(curData))
        report = [report, sprintf('<td>%.2f</td>',((length(curData))*win)/60)];
    else
        report = [report, sprintf('<td>-</td>')];
    end
    dataOut(s + 2, r) = ((length(curData))*win)/60;
end
report = [report, sprintf('</tr>\n')];

for r = 1:size(breaks, 1)
    if(r == 1)
        report = [report, sprintf('<tr><td><b>%s:</b></td>', 'Total Time')];
    end
    curData = stages(breaks(r, 1):breaks(r, 2));
    if(~isempty(curData))
        report = [report, sprintf('<td>%.2f</td>',((length(curData))*win)/60)];
    else
        report = [report, sprintf('<td>-</td>')];
    end
    dataOut(s + 3, r) = ((length(curData))*win)/60;
end

report = [report, '</tr>'];






% %get only the data that is scored
% 
% for i = 1:6
%     inds = find(stages(:, 1) == i);
%     totalTime(i) = sum((onsets(inds)/stageData.srate + stageData.win));
% end
% 
% perTime = totalTime(1:5)./sum(totalTime(1:5));
% 
% figure;
% 
% subplot(1, 2, 1)
% bar(totalTime/60)
% title('Total Time')
% set(gca, 'XTick', 1:6, 'XTickLabel', {'1'; '2'; '3'; '4'; 'REM'; 'Wake'})
% ylabel('Minutes')
% xlim([.5, 6.5])
% 
% subplot(1, 2, 2)
% bar(perTime)
% title('Percentage of Sleep')
% set(gca, 'XTick', 1:5, 'XTickLabel', {'1'; '2'; '3'; '4'; 'REM'})
% ylabel('% of sleep')
% xlim([.5, 5.5])





