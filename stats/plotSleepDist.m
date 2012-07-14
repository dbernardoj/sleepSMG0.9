function plotSleepDist(percentSleep, percentSleepSTD, newFig)
% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 11/22/2010

if(nargin < 2)
    percentSleepSTD = [];
end
if(nargin <3)
    newFig = 1;
end

if(size(percentSleep, 2) > 1)
    percentSleep = percentSleep([5, 8:15], 4);
end
if(size(percentSleepSTD, 2) > 1)
    percentSleepSTD = percentSleepSTD([5, 8:15], 4);
end   


if(newFig)
    figure('Position', [475   660   250   280]);
end

bar(repmat(percentSleep(1:7)', 2, 1)*100);
stageColors = [0 0 0; 102 255 255; 0 158 225; 102 102 255; 128 0 255; 255 0 0; 100 100 100]./255;
colormap(stageColors)

hold on
plot([.5, 1.5], [percentSleep(8), percentSleep(8)]*100, 'Color', [0 158 225]./255, 'LineWidth', 4)
plot([.5, 1.5], [percentSleep(9), percentSleep(9)]*100, 'Color', [102 102 255]./255, 'LineWidth', 4)
plot([.5, 1.5], [percentSleep(6), percentSleep(6)]*100, 'Color', [255 0 0]./255, 'LineWidth', 4)

text(.55, percentSleep(8)*100 + 2, 'NREM')
text(.55, percentSleep(9)*100 + 2, 'SW')
text(1.35, percentSleep(6)*100 + 2, 'REM')

if(~isempty(percentSleepSTD))
    errorbar(.65:.12:1.45, percentSleep(1:7)*100, percentSleepSTD(1:7)*100, '.k', 'LineWidth', 1)
end
    

xlim([.5, 1.5])
ylim([0, 100])
%legend({'wake'; 'stage1'; 'stage2'; 'stage3'; 'stage4'; 'rem'; 'mt'})
ylabel('% SPT')
set(gca, 'XTick', .65:.12:1.45, 'XTickLabel', {'Wake'; '1'; '2'; '3'; '4'; 'REM'; '  MT'})






