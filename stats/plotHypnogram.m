function plotHypnogram(stageData, cycleBounds)
% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 11/22/2010

winSize = stageData.win;
srate = stageData.srate;

onT = etime(datevec(stageData.lightsON), datevec(stageData.recStart))/60;
offT = etime(datevec(stageData.lightsOFF), datevec(stageData.recStart))/60;


figure('Position', [100, 700, 700, 300]);

subplot(2,1,1);
%plot REM events vs time
REMtime = stageData.events.REM(:, 1);
REMepochs = stageData.events.REM(:, 2);
epochBins = [0:1:180]; %in future, change 180 to total number of epochs
n_elements = histc(REMepochs,epochBins); %generate histogram count
n_elementsNonZeroLocations = n_elements ~= 0; %find non-zero elements in histogram count
timeBins = epochBins/3; % change epochBin X-locs to timeBins x-locs, based on epoch time 60/(epoch length)
REMxlocs = timeBins(n_elementsNonZeroLocations); % x1 has no y1 zeros with it.
n_elementsNonZeroKepts = n_elements(n_elementsNonZeroLocations); % n_elementsNonZeroKepts has no zeros in it.
scatter(REMxlocs,n_elementsNonZeroKepts,'square','MarkerFaceColor','k','MarkerEdgeColor','k')
xlabel('time');
set(gca, 'Xlim', stageData.stageTime([1, end]))
ylabel('# of TW per epoch');
set(gca, 'Ylim', [0, 10], 'YTick', 0:10)
title('TW events');

%plot hypnogram
subplot(2, 1, 2);
for c = 1:size(cycleBounds, 1)
    xNREM = stageData.stageTime(cycleBounds(c, 1)) + offT;
    if(cycleBounds(c, 2) == 0)
        xREM = 0;
        wNREM = stageData.stageTime(cycleBounds(c, 3)) - stageData.stageTime(cycleBounds(c, 1));
        wREM = 0;
    else
        xREM = stageData.stageTime(cycleBounds(c, 2)) + offT;
        wNREM = stageData.stageTime(cycleBounds(c, 2)) - stageData.stageTime(cycleBounds(c, 1));
        wREM = stageData.stageTime(cycleBounds(c, 3)) - stageData.stageTime(cycleBounds(c, 2));
        rectangle('Position', [xREM, 0, wREM, 8], 'FaceColor', [242, 180, 198]./255, 'LineStyle', 'none')
        hold on
    end
    rectangle('Position', [xNREM, 0, wNREM, 8], 'FaceColor', [.85 .85 .9], 'LineStyle', 'none')
end



plot([onT, onT], [0, 7], 'r', 'LineWidth', 2);
hold on
plot([offT, offT], [0, 7], 'g', 'LineWidth', 2);

plotmap = [7 4 3 2 1 5 6 0];
stageColors = [0 0 0; 102 255 255; 0 158 225; 102 102 255; 128 0 255; 255 0 0; 100 100 100; 0 0 0]./255;
stageNames = {'wake'; 'stage1'; 'stage2'; 'stage3'; 'stage4'; 'rem'; 'mt'};

for i = 0:7;
    curInds = find(stageData.stages == i);
    plot(stageData.stageTime(curInds), ones(length(curInds), 1)*plotmap(i + 1), '.', 'MarkerSize', 20, 'Color', stageColors(i+1, :));
    connectData(curInds) = plotmap(i + 1);
end

tmp = find(stageData.stages ~= 7);
%turned off xticks/xlabels b/c they are broken - dan 
%xticks = [stageData.stageTime(1), stageData.stageTime(tmp(1)), stageData.stageTime(tmp(end))];
xlabels = {datestr(stageData.recStart, 'HH:MM'), datestr(stageData.lightsOFF,'HH:MM'), datestr(stageData.lightsON, 'HH:MM')};

plot(stageData.stageTime, connectData, 'k')

%attempting to fix axis labels
%set(gca, 'Xlim', stageData.stageTime([1, end]),'XTick', xticks,'XTickLabel', xlabels,'Ylim', [0, 7],'YTick', 0:7,'YTickLabel', {'None'; 'Stage4'; 'Stage3'; 'Stage2'; 'Stage1'; 'REM'; 'MT'; 'Wake'})
set(gca, 'Ylim', [0, 7], 'YTick', 0:7,'YTickLabel', {'None'; 'Stage4'; 'Stage3'; 'Stage2'; 'Stage1'; 'REM'; 'TW'; 'Wake'})

%turned off xticks and xlabels b/c they are broken - dan 
set(gca, 'Xlim', stageData.stageTime([1, end]))
%set(gca, 'XTickLabel', xlabels)
%set(gca, 'XTick', xticks)










