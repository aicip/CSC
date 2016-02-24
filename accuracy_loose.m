function [ Accuracy ] = accuracy_loose( D, G, Events, thres_time )

% detection accuracy: calculates the ratio between the number of correctly 
% detected root events and the number of total root events according to 
% the ground truth.

% D: detection matrix
% G: groundtruth matrix
% Events: a cell storing event name in order
% thres_time: match detection and groundtruth within this time span 

Accuracy = [];
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
    for k=1:length(gt)
        if isempty(dt)
            break
        end
        if sum(abs(dt - gt(k)) <= thres_time)
            cnt = cnt + 1;
            [~, loc] = min(abs(dt - gt(k)));
            dt(loc) = [];
        end
    end
end
average = cnt / sum(sum(G>=0));

Accuracy.metric = 'Loose Detection Accuracy';
Accuracy.average = strcat(num2str(round(average*10000)/100),'%');
Accuracy.accuracy = average;

end

