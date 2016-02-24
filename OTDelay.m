function [ OTD ] = OTDelay( D, G, Events, thres_time )

% occurrence time deviation: deviation between the detected occurring time 
% and the ground truth (OT-Delay). 

% D: detection matrix
% G: groundtruth matrix
% Events: a cell storing event name in order
% thres_time: match detection and groundtruth within this time span 

OTD = [];
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

delay = zeros(length(Events),1);
cnt = delay;
for i=1:length(Events)
    d = D(i:length(Events):end,:);
    g = G(i:length(Events):end,:); 
    cnt(i) = 0;
    for j=1:size(g,1)
        if sum(g(j,:)>=0) == 0
            continue
        end
        dt = d(j,d(j,:)>=0); % delet -1
        gt = g(j,g(j,:)>=0); % delet -1
        for k=1:length(gt)
            if isempty(dt)
                break
            end
            if sum(abs(dt - gt(k)) <= thres_time)
                cnt(i) = cnt(i) + 1;
                [~, loc] = min(abs(dt - gt(k)));
                %if gt(k) > dt(loc)
                    delay(i) = delay(i) + abs(gt(k)-dt(loc));
                %end
                dt(loc) = [];
            end
        end
    end
end
average = sum(delay) / sum(cnt);

OTD.metric = 'Occurring Time Delay';
OTD.events = Events;
OTD.result = delay'./cnt';
OTD.average = strcat(num2str(round(average*1000)/1000),'s');

end

