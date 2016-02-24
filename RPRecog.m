function [ RPR ] = RPRecog( D, G, Events, thres_time )

% root-pattern recognition rate (R-P Recog): calculates the ratio between
% the number of correctly identified events 
% (i.e., events with correct type of root-pattern) and the number of 
% correctly detected events.

% D: detection matrix
% G: groundtruth matrix
% Events: a cell storing event name in order
% thres_time: match detection and groundtruth within this time span 

RPR = [];
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
cnt_i = 0;
cnt_d = 0;
for i=1:length(Events):size(D,1)
    d = D(i:i+length(Events)-1,:);
    g = G(i:i+length(Events)-1,:);
    time_d = [];
    time_g = [];
    % calculate the number of correctly identified events
    for j=1:size(g,1)
        if sum(g(j,:)>=0) == 0
            continue
        end
        dt = d(j,d(j,:)>=0); % delete useless information -1 
        gt = g(j,g(j,:)>=0);
        time_d = [time_d , dt]; % store times used for next step
        time_g = [time_g , gt];  
        for k=1:length(gt)
            if isempty(dt)
                break
            end
            if sum(abs(dt - gt(k)) <= thres_time)
                cnt_i = cnt_i + 1;
                [~, loc] = min(abs(dt - gt(k)));
                dt(loc) = [];
            end
        end
    end
    % calculate the number of correctly detected events
    if isempty(time_g)
        continue
    end
    for j=1:length(time_g)
        if sum(abs(time_d-time_g(j)) <= thres_time)
            cnt_d = cnt_d + 1;
            [~, loc] = min(abs(time_d-time_g(j)));
            time_d(loc) = [];
        end
    end
end

RPR.metric = 'Root-Pattern Recog Rate';
RPR.identi = cnt_i;
RPR.detect = cnt_d;
RPR.result = strcat(num2str(round(cnt_i/cnt_d*10000)/100),'%');

end

