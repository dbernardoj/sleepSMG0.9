function REM_Montage(handles, range)
% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 11/22/2010

EEG = handles.EEG;
scaleSpace = handles.curScale;
hideCh = handles.hideChans;
h = handles.axes1;
scaleCh = handles.scaleChans;

electrodes = {'O1-A2'; 'C4-A1'; 'O2-A1'; 'C3-A2'; 'LOC-A2'; 'ROC-A1'};
colors = 'bbbbkr';

hold(h, 'off')
for e = 1:length(electrodes)
    %find data for that electrode
    for c = 1:length(EEG.chanlocs)

        Elect = EEG.chanlocs(c).labels

        if(strcmp(electrodes{e}, Elect) == 1 && ~ismember(electrodes{e}, hideCh))
            
            if(range(1) > 0 && range(end) < length(EEG.data))
                centerData = (EEG.data(c, range))*-1;
                plotLines = plot(h, range, centerData + e*scaleSpace, colors(e));
                for i = 1:length(plotLines)
                    set(plotLines(i), 'Tag', sprintf('scale:%d;chan:%d',e*scaleSpace,c))
                    %set(plotLines(i), 'Tag', sprintf('%d',e*scaleSpace,c))
                end
                hold(h, 'on')
            
                if(ismember(electrodes{e}, scaleCh))
                    plot(h, range, zeros(size(centerData)) + e*scaleSpace - 37, 'r')
                    plot(h, range, zeros(size(centerData)) + e*scaleSpace, 'r--')
                    plot(h, range, zeros(size(centerData)) + e*scaleSpace + 37, 'r')
                end
            end
            
        end
    end
end


if(isfield(handles.stageData, 'events'))
    ylimVal = ylim(h);
    labels = fields(handles.stageData.events);
    for l = 1:length(labels)
       cur = eval(['handles.stageData.events.', labels{l}, ';']);
       curEvents = cur(cur(:, 1) >= range(1) & cur(:, 1) <= range(end), :);
       for c  = 1:size(curEvents, 1)
           m = plot(h, [curEvents(c, 1), curEvents(c, 1)], ylimVal, 'k', 'LineWidth', 2);
           set(m, 'Tag', labels{l});
           if(gca ~= h)
                axes(h)
           end
           text(curEvents(c, 1) + 5, 10, labels{l})
       end
    end
end



maxY = scaleSpace*(length(electrodes) + 1);
set(h, 'Ylim', [0, maxY], 'YTick', scaleSpace:scaleSpace:(maxY - scaleSpace), 'YTickLabel', electrodes)

srate = EEG.srate;
newX = [range(1), range(end)];
xlim(h, newX)
set(h, 'XTick', newX(1):1*srate:newX(2), 'XTickLabel', ((newX(1) - 1)/srate):1:((newX(2) - 1)/srate), 'XGrid', 'on')

onT = etime(datevec(handles.stageData.lightsON), datevec(handles.stageData.recStart))*srate;
offT = etime(datevec(handles.stageData.lightsOFF), datevec(handles.stageData.recStart))*srate;
plot(h, [onT, onT], [0, maxY], 'r', 'LineWidth', 2);
plot(h, [offT, offT], [0, maxY], 'g', 'LineWidth', 2);

