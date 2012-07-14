function Reliability = Reliability(stageData1,stageData2,outname)
%% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 2011
%
% Reliability(stageData1,stageData2,outname)
%
% Computes Reliability Agreement between two scorers (Scorer 1 and Scorer
% 2). Takes as input the filenames of two 'stageData.mat' files, one for
% each scorer (stageData1, and stageData2, respectively).
%
% Computes agreement as well as cohen's kappa for both stages 3 and 4
% separated as well as collapsed
%
% Results printed to the command prompt as well to an html file named
% according to the outname parameter (default: 'Reliability.html')
%
% Inputs:
% stageData1 - stageData struct for reference.
% stageData2 - stageData struct to test for reliability to stageData1.
% outname (optional) -filename to save the output as [Default:Reliability]

if nargin<3
    
    outname = 'Reliability';
    
end


% load data
if(ischar(stageData1))
    load(stageData1);
    stages1 = stageData.stages;
else
    stages1 = stageData1;
end
if(ischar(stageData2))
    load(stageData2);
    stages2 = stageData.stages;
else
    stages2 = stageData2;
end

% trim off non-scored epochs
trim1 = find(stages1~=7);
trim2 = find(stages2~=7);

if(trim1(1) < trim2(1))
    display('Warning: scorer 1  started scoring ', num2str(trim2(1) - trim1(1)), 'epochs earlier than scorer 2')
    trim1(trim1 < trim2(1)) = [];
elseif(trim1(1) > trim2(1))
    display('Warning: scorer 2  started scoring ', num2str(trim1(1) - trim2(1)), 'epochs earlier than scorer 1')
    trim2(trim2 < trim1(1)) = [];
end

if(trim1(end) < trim2(end))
    display('Warning: scorer 1  stopped scoring ', num2str(trim2(end) - trim1(end)), 'epochs earlier than scorer 2')
    trim2(trim2 > trim1(end)) = [];
elseif(trim1(end) > trim2(end))
    display('Warning: scorer 2  stopped scoring ', num2str(trim1(end) - trim2(end)), 'epochs earlier than scorer 1')
    trim1(trim1 > trim2(end)) = [];
end

stages1 = stages1(trim1(1):trim1(end));
stages2 = stages2(trim2(1):trim2(end));

size(stages1)
size(stages2)

% tabulate agreement
for i = 0:6
    for j = 0:6
        CrossTab(i+ 1, j + 1) = sum(stages2 == i & stages1 == j);
    end
end

[k agreement] = kappaCalc(CrossTab);

table = zeros(7, 7);

for t = 0:6
    
    for t2 = 0:6
        table(t+1, t2+1) = sum(stages2 == t & stages1 == t2);
      
    end
    
end

[k agreement] = kappaCalc(table);

% same stats with 3 and 4 collapsed

% EDITS (JMS) 1/4/12 -- FIXED BUG WHEREAS REM WASNT COUNTED IN CODE WHEN
% MATRIX WAS CREATED. ALL SW RECODED AS 3, REM as 4, MT as 5. STAGES NOW
% RUN 0 - 5.
stages1_SW = stages1;
stages1_SW(find(stages1_SW==4))=3;
stages1_SW(find(stages1_SW==5))=4;
stages1_SW(find(stages1_SW==6))=5;
stages2_SW = stages2;
stages2_SW(find(stages2_SW==4))=3;
stages2_SW(find(stages2_SW==5))=4;
stages2_SW(find(stages2_SW==6))=5;
tableSW = zeros(6, 6);

for t = 0:5
    
    for t2 = 0:5
        tableSW(t+1, t2+1) = sum(stages2_SW == t & stages1_SW == t2);
      
    end
    
end

[kSW agreementSW] = kappaCalc(tableSW);

% Create Reliability Struct

Reliability.SWSeperated.AgreementTable = [[table;sum(table,1)] [sum(table(1,:));[sum(table(2,:));sum(table(3,:));sum(table(4,:));sum(table(5,:));sum(table(6,:));sum(table(7,:))]; sum(sum(table))]];
Reliability.SWSeperated.PercentAgreements = [(diag(table)'./sum(table,1)).*100 sum(diag(table))'./sum(sum(table))*100];
Reliability.SWSeperated.Kappa = k;
Reliability.SWSeperated.Agreement = agreement;

Reliability.SWCollapsed.AgreementTable = [[tableSW;sum(tableSW,1)] [sum(tableSW(1,:));[sum(tableSW(2,:));sum(tableSW(3,:));sum(tableSW(4,:));sum(tableSW(5,:));sum(tableSW(6,:))]; sum(sum(tableSW))]];
Reliability.SWCollapsed.PercentAgreements = [(diag(tableSW)'./sum(tableSW,1)).*100 sum(diag(tableSW))'./sum(sum(tableSW))*100];
Reliability.SWCollapsed.Kappa = kSW;
Reliability.SWCollapsed.Agreement = agreementSW;

% print results to command prompt
fprintf(1,'\n***SCORING RELIABILITY (SW SEPARATED)***\n\n');
fprintf(1,'Epoch Agreement (Scorer 1 in Columns, Scorer 2 in Rows)\n\n');
fprintf(1,'\tW\tS1\tS2\tS3\tS4\tREM\tMT\tTOTAL\n');
fprintf(1,'W\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',table(1,:),sum(table(1,:)));
fprintf(1,'S1\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',table(2,:),sum(table(2,:)));
fprintf(1,'S2\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',table(3,:),sum(table(3,:)));
fprintf(1,'S3\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',table(4,:),sum(table(4,:)));
fprintf(1,'S4\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',table(5,:),sum(table(5,:)));
fprintf(1,'REM\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',table(6,:),sum(table(6,:)));
fprintf(1,'MT\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',table(7,:),sum(table(7,:)));
fprintf(1,'TOTAL\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',sum(table,1),sum(sum(table)));
fprintf(1,'\n\nPercent Agreement of Scorer 2 with Scorer 1\n\n');
fprintf(1,'W\tS1\tS2\tS3\tS4\tREM\tMT\tTotal\n');
fprintf(1,'%.2f%%\t%.2f%%\t%.2f%%\t%.2f%%\t%.2f%%\t%.2f%%\t%.2f%%\t%.2f%%\n\n',(diag(table)'./sum(table,1)).*100,sum(diag(table))'./sum(sum(table))*100);
fprintf(1,'Cohen''s kappa = %.2f\n\n%s\n\n',k, agreement);
fprintf(1,'--------------------------------------------------------------------\n\n');
fprintf(1,'***SCORING RELIABILITY (SW COLLAPSED)***\n\n');
fprintf(1,'Epoch Agreement (Scorer 1 in Columns, Scorer 2 in Rows)\n\n');
fprintf(1,'\tW\tS1\tS2\tSW\tREM\tMT\tTOTAL\n');
fprintf(1,'W\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',tableSW(1,:),sum(tableSW(1,:)));
fprintf(1,'S1\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',tableSW(2,:),sum(tableSW(2,:)));
fprintf(1,'S2\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',tableSW(3,:),sum(tableSW(3,:)));
fprintf(1,'SW\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',tableSW(4,:),sum(tableSW(4,:)));
fprintf(1,'REM\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',tableSW(5,:),sum(tableSW(5,:)));
fprintf(1,'MT\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',tableSW(6,:),sum(tableSW(6,:)));
fprintf(1,'TOTAL\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',sum(tableSW,1),sum(sum(tableSW)));
fprintf(1,'\n\nPercent Agreement of Scorer 2 with Scorer 1\n\n');
fprintf(1,'W\tS1\tS2\tSW\tREM\tMT\tTotal\n');
fprintf(1,'%.2f%%\t%.2f%%\t%.2f%%\t%.2f%%\t%.2f%%\t%.2f%%\t%.2f%%\n\n',(diag(tableSW)'./sum(tableSW,1)).*100,sum(diag(tableSW))'./sum(sum(tableSW))*100);
fprintf(1,'Cohen''s kappa = %.2f\n\n%s\n\n',kSW, agreementSW);

% print same results to html file

report = '<html>';

report = [report, sprintf('<h1>SCORING RELIABILITY (SW SEPARATED)</h1>\n')];
report = [report,sprintf('<h2>Epoch Agreement (Scorer 1 in Columns, Scorer 2 in Rows)</h2>\n')];
report = [report,sprintf('<table cellpadding="5">\n<tr><td><td><td><td><b>W</b></td><td><td><td><b>S1</b></td><td><td><td><b>S2</b></td><td><td><td><b>S3</b></td><td><td><td><b>S4</b></td><td><td><td><b>REM</b></td><td><td><td><b>MT</b></td><td><td><td><b>TOTAL</b></tr>\n')];
report = [report,sprintf('<tr><td><b>W</b><td><td><td><b>%d</b></td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></tr>\n',table(1,:),sum(table(1,:)))];
report = [report,sprintf('<tr><td><b>S1</b><td><td><td>%d</td><td><td><td><b>%d</b></td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></tr>\n',table(2,:),sum(table(2,:)))];
report = [report,sprintf('<tr><td><b>S2</b><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></tr>\n',table(3,:),sum(table(3,:)))];
report = [report,sprintf('<tr><td><b>S3</b><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></tr>\n',table(4,:),sum(table(4,:)))];
report = [report,sprintf('<tr><td><b>S4</b><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></tr>\n',table(5,:),sum(table(5,:)))];
report = [report,sprintf('<tr><td><b>REM</b><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></td><td><td><td>%d</td><td><td><td><b>%d</b></tr>\n',table(6,:),sum(table(6,:)))];
report = [report,sprintf('<tr><td><b>MT</b><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></td><td><td><td><b>%d</b></tr>\n',table(7,:),sum(table(7,:)))];
report = [report,sprintf('<tr><td><b>TOTAL</b><td><td><td><b>%d</b></td><td><td><td><b>%d</b></td><td><td><td><b>%d</b></td><td><td><td><b>%d</b></td><td><td><td><b>%d</b></td><td><td><td><b>%d</b></td><td><td><td><b>%d</b></td><td><td><td><b>%d</b></tr>\n',sum(table,1),sum(sum(table)))];
report = [report, '</table>'];
report = [report,sprintf('<h2>Percent Agreement of Scorer 2 with Scorer 1</h2>\n')];
report = [report,sprintf('<table cellpadding="5">\n<tr><td><b>W</b></td><td><td><td><b>S1</b></td><td><td><td><b>S2</b></td><td><td><td><b>S3</b></td><td><td><td><b>S4</b></td><td><td><td><b>REM</b></td><td><td><td><b>MT</b></td><td><td><td><b>TOTAL</b></tr>\n')];
report = [report,sprintf('<tr><td>%.2f%%</td><td><td><td>%.2f%%</td><td><td><td>%.2f%%</td><td><td><td>%.2f%%</td><td><td><td>%.2f%%</td><td><td><td>%.2f%%</td><td><td><td>%.2f%%</td><td><td><td>%.2f%%</tr>\n',(diag(table)'./sum(table,1)).*100,sum(diag(table))'./sum(sum(table))*100)];
report = [report,'</table>'];
report = [report,sprintf('<br><b>Cohen''s &kappa; </b>= %.2f<br>',k)];
report = [report,sprintf('<br><b>%s</b><br>\n',agreement)];
report = [report, '<br><hr>'];
report = [report, sprintf('<h1>SCORING RELIABILITY (SW COLLAPSED)</h1>\n')];
report = [report,sprintf('<h2>Epoch Agreement (Scorer 1 in Columns, Scorer 2 in Rows)</h2>\n')];
report = [report,sprintf('<table cellpadding="5">\n<tr><td><td><td><td><b>W</b></td><td><td><td><b>S1</b></td><td><td><td><b>S2</b></td><td><td><td><b>SW</b></td><td><td><td><b>REM</b></td><td><td><td><b>MT</b></td><td><td><td><b>TOTAL</b></tr>\n')];
report = [report,sprintf('<tr><td><b>W</b><td><td><td><b>%d</b></td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></tr>\n',tableSW(1,:),sum(tableSW(1,:)))];
report = [report,sprintf('<tr><td><b>S1</b><td><td><td>%d</td><td><td><td><b>%d</b></td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></tr>\n',tableSW(2,:),sum(tableSW(2,:)))];
report = [report,sprintf('<tr><td><b>S2</b><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></tr>\n',tableSW(3,:),sum(tableSW(3,:)))];
report = [report,sprintf('<tr><td><b>SW</b><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></tr>\n',tableSW(4,:),sum(tableSW(4,:)))];
report = [report,sprintf('<tr><td><b>REM</b><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></td><td><td><td>%d</td><td><td><td><b>%d</b></tr>\n',tableSW(5,:),sum(tableSW(5,:)))];
report = [report,sprintf('<tr><td><b>MT</b><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td>%d</td><td><td><td><b>%d</b></td><td><td><td><b>%d</b></tr>\n',tableSW(6,:),sum(tableSW(6,:)))];
report = [report,sprintf('<tr><td><b>TOTAL</b><td><td><td><b>%d</b></td><td><td><td><b>%d</b></td><td><td><td><b>%d</b></td><td><td><td><b>%d</b></td><td><td><td><b>%d</b></td><td><td><td><b>%d</b></td><td><td><td><b>%d</b></tr>\n',sum(tableSW,1),sum(sum(tableSW)))];
report = [report, '</table>'];
report = [report,sprintf('<h2>Percent Agreement of Scorer 2 with Scorer 1</h2>\n')];
report = [report,sprintf('<table cellpadding="5">\n<tr><td><b>W</b></td><td><td><td><b>S1</b></td><td><td><td><b>S2</b></td><td><td><td><b>SW</b></td><td><td><td><b>REM</b></td><td><td><td><b>MT</b></td><td><td><td><b>TOTAL</b></tr>\n')];
report = [report,sprintf('<tr><td>%.2f%%</td><td><td><td>%.2f%%</td><td><td><td>%.2f%%</td><td><td><td>%.2f%%</td><td><td><td>%.2f%%</td><td><td><td>%.2f%%</td><td><td><td>%.2f%%</tr>\n',(diag(tableSW)'./sum(tableSW,1)).*100,sum(diag(tableSW))'./sum(sum(tableSW))*100)];
report = [report,'</table>'];
report = [report,sprintf('<br><b>Cohen''s &kappa; </b>= %.2f<br>',kSW)];
report = [report,sprintf('<br><b>%s</b><br><br>\n',agreementSW)];

fid = fopen([outname, '.html'], 'w');
fwrite(fid, report);

% Create Reliability Struct

Reliability.SWSeperated.AgreementTable = [[table;sum(table,1)] [sum(table(1,:));[sum(table(2,:));sum(table(3,:));sum(table(4,:));sum(table(5,:));sum(table(6,:));sum(table(7,:))]; sum(sum(table))]];
Reliability.SWSeperated.PercentAgreements = [(diag(table)'./sum(table,1)).*100 sum(diag(table))'./sum(sum(table))*100];
Reliability.SWSeperated.Kappa = k;
Reliability.SWSeperated.Agreement = agreement;

Reliability.SWCollapsed.AgreementTable = [[tableSW;sum(tableSW,1)] [sum(tableSW(1,:));[sum(tableSW(2,:));sum(tableSW(3,:));sum(tableSW(4,:));sum(tableSW(5,:));sum(tableSW(6,:))]; sum(sum(tableSW))]];
Reliability.SWCollapsed.PercentAgreements = [(diag(tableSW)'./sum(tableSW,1)).*100 sum(diag(tableSW))'./sum(sum(tableSW))*100];
Reliability.SWCollapsed.Kappa = kSW;
Reliability.SWCollapsed.Agreement = agreementSW;

eval(['save ',outname,' Reliability;']);
end

function [k agreement] = kappaCalc(table)

% observed agreement
Po = sum(diag(table))./sum(sum(table)); 
Pe = 0;
for x = 1:size(table,1)
    % calculate expected agreement if at chance
    Pe = Pe + sum(table(x,:))/sum(sum(table))*sum(table(:,x))/sum(sum(table)); 
end
% calculate cohen's kappa
k = (Po-Pe)/(1-Pe); 

% interpret kappa according to conventions *approximate*
if k < 0  
    agreement = 'No Agreement';
elseif k >=0 && k <= .20    
    agreement = 'Slight Agreement';
elseif k > .20 && k <= .40  
    agreement = 'Fair Agreement';    
elseif k > .40 && k <= .60    
    agreement = 'Moderate Agreement';    
elseif k > .60 && k <= .80    
    agreement = 'Substantial Agreement';    
elseif k > .80 && k < 1    
    agreement = 'Near Perfect Agreement';    
elseif k >= 1    
    agreement = 'Perfect Agreement';    
end
    
end


