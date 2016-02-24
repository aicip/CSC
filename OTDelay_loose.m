function [ OTD ] = OTDelay_loose( D, G, Events, thres_time )

% occurrence time deviation: deviation between the detected occurring time 
% and the ground truth (OT-Delay) 

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

delay = 0;
cnt = 0;
for i=1:length(Events):size(D,1)
    d = D(i:i+length(Events)-1,:);
    g = G(i:i+length(Events)-1,:);
    dt = d(d>=0); % delet -1
    gt = g(g>=0); % delet -1
    for k=1:length(gt)
        if isempty(dt)
            break
        end
        if sum(abs(dt - gt(k)) <= thres_time)
            cnt = cnt + 1;
            [~, loc] = min(abs(dt - gt(k)));
            delay = delay + abs(gt(k)-dt(loc));
            dt(loc) = [];
        end
    end
end
average = delay / cnt;

OTD.metric = 'Loose Occurring Time Delay';
OTD.average = strcat(num2str(round(average*1000)/1000),'s');

end

