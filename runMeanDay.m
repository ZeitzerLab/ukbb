%% Sherlock Mean Day

%% Paths
dpath = getenv('DATACSV');
avgDaypath = getenv('DATAAVGDAY');
dcode = getenv('CODEUKBB');
dcomm = getenv('DATACOMM');
fcomm = getenv('FILE');

% Get list of files to run
fns = importdata(fcomm);

% number of parallel pool workers (usually 20 for 1 node on sherlock)
%parpool('local', 20, 'AttachedFiles', {fullfile(dcode,'gapDur.m'),fullfile(dcode,'medianImputation.m')})

% Loop through list of files
for i = 1:length(fns)
    try
        dt = readtable(fullfile(dpath,fns{i}),'Delimiter', ',');
        dt2 = readtable(fullfile(dpath,fns{i}));
        ttt=[];
        for jj = 1:length(dt2.Var2)
            ttt = [ttt;datetime(dt2.Var1(jj)) + duration(dt2.Var2{jj}(1:12))];
        end
        
        dt.acc_med
        tmins = 60*hour(ttt)+minute(ttt)+(second(ttt)./60);
        times = unique(tmins);
        
        dayMin = nan(1,length(times)); 
        for j = 1:length(times)
            dayMin(j) = mean(act(tmins == times(j)));
        end 
        Subject =  {fns{i}(1:end-15)};   
        T = [table(Subject),array2table(dayMin)];

        writetable(T,fullfile(avgDaypath,sprintf('%s-avgDay.csv',Subject)),'Delimiter',',')
    catch
    end
end
