function plotSleepLat(sleepLat)


figure('Position', [475   800   350   150]);

barh(repmat(sleepLat', 2, 1));

stageColors = [102 255 255; 0 158 225; 102 102 255; 128 0 255; 255 0 0]./255;
colormap(stageColors)

ylim([.5, 1.5])
xlim([0, 120])

xlabel('Minutes')
set(gca, 'YTick', .65:.15:1.25, 'YTickLabel', {'1'; '2'; '3'; '4'; 'REM'})



