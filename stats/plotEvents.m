



REMtime = stageData.events.REM(:, 1)
REMepochs = stageData.events.REM(:, 2)
%plotmatrix(REMtime,REMepochs)
epochBins = [0:1:300]
n_elements = histc(REMepochs,epochBins)
scatter(epochBins*20,n_elements,'square','MarkerFaceColor','k','MarkerEdgeColor','k')

%M = [];
%for i = 1:1:20;
%seq = 0 + 25.*randn(1, i*100);
%m = mean (seq);
%M(1,i) = m;
%end 
%figure,ploty(1:20,M,1:20,V)