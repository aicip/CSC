function [ D, G ] = dataconverter (strfile, detect, indicator)
% indicator - is a cell to indicat the meaning of number in detect.
% detect - a cell to store the time of events. 
% strfile - name of the corresponding data file.
% 
% Example:
% file = 'ls_gt_ls';
% result = { gt , ls , lt };
% events = {'gt','ls','lt'};
% [D, G] = dataconverter (file, result, events)
% 
D = []; G = [];
if nargin < 3
    disp('Error: Not enough arguments!')
    return
end
if length(indicator) ~= length(detect)
    disp('Error: The first two arguments must have the same dimension!')
    return
end
if isempty(detect)
    disp('Error: Detected result cannot be empty!')
    return
end
for i=1:length(detect)
    if min(size(detect{i})) > 1
        disp('Error: Members in detected resulit must be vectors !')
        return
    end
    detect{i} = sort(detect{i});
end

d = 10; g = 5; % length of data set for detection and groudtruth
[ times, events ] = parsename( strfile );
D = -1*ones(length(events),d); % store detection
G = -1*ones(length(events),g); % store groundtruth
for i=1:length(detect)
    ind = find(ismember(events,indicator{i}));
    for j=1:length(detect{i})
        if isempty(detect{ind})
            break
        end
        D(i,j) = detect{i}(j);
    end
    for j=1:length(times{i})
        if isempty(times{ind})
            break
        end
        G(i,j) = times{ind}(j);
    end
end
end

function [ times, events ] = parsename( strfile )
ind = strfind(strfile,'.xlsx');
strfile = strfile(1:ind(1)-1);
events = {'gt','lt','ls'};
times =  cell(length(events),1);
for i=1:length(times)
    index = strfind(strfile,events{i});
    if isempty(index)
        continue
    end
    for j=1:length(index)
        temp = strfile(index(j):end);
        id = strfind(temp, '_');
        if length(id) == 1
            times{i} = [times{i} ; str2double(temp(id+1:end))];
        else
            times{i} = [times{i} ; str2double(temp(id(1)+1:id(2)-1))];
        end
    end
    times{i} = sort(times{i});
end
end

