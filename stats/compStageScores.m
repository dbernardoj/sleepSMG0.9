function compStageScores(stageData1, stageData2)
% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 11/22/2010

if(length(stageData1) < length(stageData2))
    stageData2 = stageData2(1:length(stageData1));
elseif(length(stageData1) > length(stageData2))
    stageData1 = stageData1(1:length(stageData2));
end



%build full comparison
fullComp = zeros(7, 7);
for i = 0:6
    for j = 0:6
        fullComp(i + 1, j + 1) = sum(stageData1 == i & stageData2 == j);
        
    end
end

figure
imagesc(fullComp)
caxis([0, max(max(fullComp))])
colormap hot

set(gca, 'YTick', 1:7, 'YTickLabel', {'Wake'; 'Stage1'; 'Stage2'; 'Stage3'; 'Stage4'; 'REM'; 'MT'})
set(gca, 'XTick', 1:7, 'XTickLabel', {'Wake'; 'Stage1'; 'Stage2'; 'Stage3'; 'Stage4'; 'REM'; 'MT'})








