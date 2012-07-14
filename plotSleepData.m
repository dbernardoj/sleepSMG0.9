function plotSleepData(handles, range)
%% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 2011

plotFCN = get(handles.plotSleepIN, 'String');
boxInd = get(handles.plotSleepIN, 'Value');


eval([plotFCN{boxInd}, '(handles, range);']);






