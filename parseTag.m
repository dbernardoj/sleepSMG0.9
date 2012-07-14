function val = parseTag(tagIn, key)
%% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 2011

val = [];
tail = tagIn;
while(~isempty(tail))
    [hd, tail] = strtok(tail, ';');
    [hd2, tail2] = strtok(hd, ':');
    if(strcmp(hd2, key))
        val = tail2(2:end);
    end
end

















