function writeStruct(structIn, outname)
% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 11/22/2010


fid = fopen(outname, 'w');


fieldsIn = fields(structIn);
for f = 1:length(fieldsIn)
    fwrite(fid, sprintf('%s\n', fieldsIn{f}));
    cur = eval(['structIn.', fieldsIn{f}]);
    
    if(ischar(cur))
        fwrite(fid, sprintf('%s\n', cur));
    elseif(iscell(cur))
        %skip
    else
        for i = 1:size(cur, 1)
            for j = 1:(size(cur, 2) - 1)
                fwrite(fid, sprintf('%.5f,', cur(i, j)));
            end
            fwrite(fid, sprintf('%.5f\n', cur(i, j + 1)));
        end;
    end
    
end

fclose(fid);









