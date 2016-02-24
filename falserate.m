function [ FalsRate ] = falserate( D, G, Events, thres_time )

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
fals = zeros(length(Events),1);
cnt = fals;
for i=1:length(Events)
    d = D(i:length(Events):end,:);
    g = G(i:length(Events):end,:); 
    cnt(i) = 0;
    for j=1:size(d,1)
        if sum(d(j,:)>=0) == 0
            continue
        end
        dt = d(j,d(j,:)>=0); % delet -1
        gt = g(j,g(j,:)>=0); % delet -1
        for k=1:length(dt)
            if isempty(gt)
                cnt(i) = cnt(i) + length(dt)-k+1;
                break
            end
            if sum(abs(gt - dt(k)) > thres_time) == length(gt)
                cnt(i) = cnt(i) + 1;
            else
                [~, loc] = min(abs(gt - dt(k)));
                gt(loc) = [];
            end
        end
    end
    fals(i) = cnt(i) / sum(sum(g>=0));
end
average = sum(cnt) / sum(sum(G>=0));

FalsRate.metric = 'False Alarm Rate';
FalsRate.events = Events;
FalsRate.result = fals';
FalsRate.average = strcat(num2str(round(average*10000)/100),'%');;

end

