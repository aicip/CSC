function [ FalsRate ] = falserate_loose( D, G, Events, thres_time )

% false alarm rate : calculates the ratio between the number of detected 
% root events not really happen and the total number of root events 
% according to the ground truth. 

% D: detection matrix
% G: groundtruth matrix
% Events: a cell storing event name in order
% thres_time: match detection and groundtruth within this time span 

FalsRate = [];
if nargin < 3
    disp('Error: Not enough arguments!')
    return
end
if nargin == 3 
    thres_time = 7; % second
end
if size(D,1) ~= size(G,1)
    disp('Error: D and G must be the same number of row')
    return
end
if mod(size(D,1),length(Events))
    disp('Error: Event number does not match')
    return
end

cnt = 0;
for i=1:length(Events):size(D,1)
    d = D(i:i+length(Events)-1,:);
    g = G(i:i+length(Events)-1,:);  
    dt = d(d>=0); % delet -1
    gt = g(g>=0); % delet -1
    if isempty(dt)
        continue
    end
    for k=1:length(dt)
        if isempty(gt)
            cnt = cnt + length(dt)-k+1;
            break
        end
        if sum(abs(gt - dt(k)) > thres_time) == length(gt)
            cnt = cnt + 1;
        else
            [~, loc] = min(abs(gt - dt(k)));
            gt(loc) = [];
        end
    end
end
average = cnt / sum(sum(G>=0));

FalsRate.metric = 'Loose False Alarm Rate';
FalsRate.average = strcat(num2str(round(average*10000)/100),'%');;
FalsRate.falsrate = average;
end

