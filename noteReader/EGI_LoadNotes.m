function stageData = loadEGInotes(stageData, notesFile, recStart, outname)
% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 11/22/2010

recStart = datenum([head(2:end), '0'], 'HH:MM:SS.FFF');

if(nargin < 2)
    outname = []
end

notes = importdata(notesFile);
recStart = 0;

if(~isfield(stageData, 'events'))
    stageData.events = [];
end

for i = 3:length(notes)
    [head, tail] = strtok(notes{i}, '_');
    
    if(strcmp(tail(1:4), ',Start Recording'))
        recStart = datenum([head(2:end), '0'], 'HH:MM:SS.FFF');
        
    elseif(recStart > 0)
        tail(tail == ' ') = '';
        tail(tail == '-') = '';
        tail(tail == '/') = '';
        tail(tail == '<') = '';
        tail(tail == '>') = '';
        tail(tail == '.') = '';
        tail(tail == ':') = '';
        tail(tail == '''') = '';
        curTime = datenum([head(2:end), '0'], 'HH:MM:SS.FFF');
        if(curTime < recStart)
            curTime = curTime + 1;
        end
        curPoint = etime(datevec(curTime), datevec(recStart))*400;
        etime(datevec(curTime), datevec(recStart));
        dataOut = [curPoint, 0, 0];

        if(isfield(stageData.events, tail(2:end)))
            cur = eval(['stageData.events.', tail(2:end), ';']);
            dataOut = [cur; dataOut];
        end
        try
            eval(['stageData.events.', tail(2:end), '= dataOut;'])

        catch
            eval(['stageData.events.', 's', tail(2:end), '= dataOut;'])
        end
    end
end


if(~isfield(stageData, 'recStart'))
    stageData.recStart = recStart;
elseif(stageData.recStart ~= recStart)
    inputRecStart = datestr(stageData.recStart, 'HH:MM:SS.FFF');
    notesRecStart = datestr(recStart, 'HH:MM:SS.FFF');
    fprintf('The origional recording start (%s) does not match the notes recording start (%s) (Using origional record start)', inputRecStart, notesRecStart);
end

nLoff = recStart + (stageData.events.LightsOut(1)/400)/86400;
if(~isfield(stageData, 'lightsOFF'))
    stageData.lightsOFF = nLoff;
    
elseif(stageData.lightsOFF ~= nLoff)
    inputRecStart = datestr(stageData.lightsOFF, 'HH:MM:SS.FFF');
    notesRecStart = datestr(nLoff, 'HH:MM:SS.FFF');
    fprintf('The origional lights off (%s) does not match the notes lights off (%s) (Using origional lights off)', inputRecStart, notesRecStart);
end  


nLon = recStart + (stageData.events.LightsOn(1)/400)/86400;
if(~isfield(stageData, 'lightsON'))
    stageData.lightsON = nLon;
    
elseif(stageData.lightsON ~= nLon)
    inputRecStart = datestr(stageData.lightsON, 'HH:MM:SS.FFF');
    notesRecStart = datestr(nLon, 'HH:MM:SS.FFF');
    fprintf('The origional lights on (%s) does not match the notes lights on (%s) (Using origional lights on)', inputRecStart, notesRecStart);
end  







