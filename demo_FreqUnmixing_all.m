% Multiple Events Detection for Large Power Grid System via Sparse Coding
% Author: Yang Song, EECS, UTK
% Email:  ysong18@utk.edu
% Date:   July 12, 2014
% Copyright (c) 2014.

% clear all 
close all
clc
warning off

%% load single files
dataPath = 'Signal_Files/M3C/';
files = dir(fullfile(dataPath,'*.mat'));

%% load roots
% % please keep the order as gt, lt, ls
load('Root_Files/roots.mat')
%% initialization
debug = 0;
showplot = 0;
saveplot = 0;
step = 1;
% sparse coefficient: the larger the sparser. 
% try from a relativly small value, and increase the value 
% if the result is not sparse enough.
lambda = [27];
%lambda = [0.01, 0.1, 0.3, 0.5, 1, 5, 10, 15, 20];
% tolerance of accepting sparse coding result. 
rel_error = 0.1;
rel_tol = 1;
% threshold of combining the events closed in time
thres_time = 3.5; % second 3.5
% threshold of filtering low weighted events
thres_rate = 0.05;  % within root
thres_rate2 = 0.05;% between root 
% for statistics of results 0.05
Detect = [];
Ground = [];

% building dictionary will cost some memory, we have already save the
% dicitonary into dictionary_5.mat, if memory is not enough, you can
% directly load the existing dictionary.
% load('dictionary_5.mat')
 
len = importdata(strcat(dataPath, files(1).name));
[D, TypeNum, Sc, Tc] = builddictionary_all(length(len), roots, step);  
A = D'*D;

for loop=1:length(files)
    %% load signal
    disp(strcat(num2str(loop),{'. '},files(loop).name))
    y = importdata(strcat(dataPath, files(loop).name));
    %plot(y);
    % normalize the input signal
%     y = normalization(freq);
    y = zscore(y);
    y = y - repmat(y(1), size(y,1), 1);
    
%     plot(y,'k','Linewidth',2)
%     ylim([min(y(1:300))-.5 max(y(1:300))+.5])
%     xlim([1 300])
%     xlabel('Time (300 samples for 30s)', 'Fontsize', 25)
%     set(gca, 'Fontsize', 23);
%     waitforbuttonpress
%     continue
    %% build dictionary
    stream_length = length(y);
    % sampling period
    T = 0.1; % second
    % time span of the input signal
    stream_during = stream_length * T; % second
    %[D, TypeNum, Sc, Tc] = builddictionary(stream_length, roots); 
    % no trivial
%    [D, TypeNum, Sc, Tc] = builddictionary_all(stream_length, roots, 0);
    
    %% estimate sparce coefficients
    
    b = D'*y;
    for i = 1:length(lambda)
        S = sparsecoding(lambda(i), A, b);
        % condition of stopping iteration:
        % this part can be modified for different purpose
        est_error = sum(abs(y-D*S))/stream_length
        if est_error <= rel_error && sum(S(1:Sc)>0) >= rel_tol
            break
        end
%         if sum(S(1:Sc)>0) <= rel_tol
%             break
%         end
    end
    
    %% for debug: show estimation result 
    if debug
        f0 = figure;
        % original signal
        h1 = plot(y,'b'); hold on
        % estimatied signal
        h2 = plot(D*S,'r--');
        title_str = strcat( 'error=',num2str(est_error), {', '}, ...
                            '\lambda=',num2str(lambda(i)));
        % raw members
        for i=1:length(S)
            if S(i) ~= 0
                hold on
                h3 = plot(D(:,i).*S(i),'k:');
            end
        end
        legend('Original signal','Recovered signal','Weighted endmembers')
        set(gca, 'Fontsize', 16);
        %title(title_str)
        %waitforbuttonpress
        %close all
    end
    
    %% format coefficients
    % copy original S for plot 
    Sori = S;
    % we are only interested in shift coefficients
    S = S(1:Sc);
    %S(find(abs(S)<threshold))=0;
    % get non-zero coefficient signatures
    id = find(S);
    % event coefficient
    id_gray= zeros(1, length(id));
    % event type
    id_tag = zeros(1, length(id));
    % event occurrence time
    id_time= zeros(1, length(id));
    TimeSpan = Sc/sum(TypeNum);
    for i=1:length(id)
        eventpos  = ceil(id(i)/TimeSpan);
        id_gray(i)= S(id(i));
        id_tag(i) = eventpos; 
        id_time(i)= mod(id(i),TimeSpan);
        if id_time(i)==0 
            id_time(i)=TimeSpan; 
        end
    end
    % orgaize coefficient and time by events 
    events = cell(sum(TypeNum),1);
    for i=1:sum(TypeNum)
        events{i}=[id_gray(id_tag==i)', ...
            id_time(id_tag==i)'.*step.*stream_during/stream_length+1];
    end
    % format: member = {[weight, time]}
    index = [
        1, TypeNum(1);
        TypeNum(1)+1, sum(TypeNum(1:2));
        sum(TypeNum(1:2))+1, sum(TypeNum)];
    members = cell(3,1);
    for type = 1:size(index,1)
        for i=index(type,1):index(type,2)   
            if isempty(events{i})
                continue
            end 
            events{i}(events{i}(:,1)==0,:) = [];
            if isempty(events{i})
                continue
            end 
            for j=1:size(events{i},1)
                members{type} = [members{type}; events{i}(j,:)];
            end
        end
    end
    members_old = members;
    %% combine losed events members belong to the same root 
    temp = [];
    for i=1:length(members)
        if isempty(members{i}) 
            continue 
        end
        centers = 1;
        while(1)
            flag = 0;
            while(flag == 0)
                [IDX, C] = kmeans(members{i}(:,2), centers, ...
                     'EmptyAction', 'drop');
                if ~isnan(sum(C))
                    flag = 1;
                end
            end
            flag = 1;
            for k=1:centers
                %if sum(abs(members{i}(IDX==k,2)-C(k))>thres_time)
                if max(members{i}(IDX==k,2))-min(members{i}(IDX==k,2))>thres_time
                    flag = 0;
                    centers = centers + 1;
                    break
                end
            end
            if flag
                w = [];
                t = [];
                for l=1:length(C)
                    % accumulated weight
                    w = [w; sum(members{i}(IDX==l,1))];
                    % time calculation
                    wt = members{i}(IDX==l,:);
                    t = [t; wt(:,1)'*wt(:,2)./sum(wt(:,1))];
                end
                break
            end
        end
        members{i} = [w,t];
        % delete tiny members
        members{i}(members{i}(:,1)./max(members{i}(:,1)) < thres_rate,:) = [];
        temp = [temp;members{i}];
    end
    % delet tiny members through comparison betweent different roots
    if isempty(temp)
        continue;
    end
    base = max(temp(:,1));
    temp = [];
    for i=1:length(members)
        if isempty(members{i}) 
            continue 
        end
        members{i}(members{i}(:,1)./base < thres_rate2,:) = [];
        temp = [ temp; [i*ones(size(members{i},1),1),members{i}] ];
    end
    
    %% solve contradiction:
    % in practice, it is seen as impossible that two different type of
    % roots occur within a small time span (e.g. 2 second)
    centers = 1;
    while(1)
        flag = 0;
        while(flag == 0)
            [IDX, C] = kmeans(temp(:,3), centers, ...
                'Start', 'uniform', 'EmptyAction', 'drop');
            if ~isnan(sum(C))
                flag = 1;
            end
        end
        flag = 1;
        for k=1:centers
            %if sum(abs(temp(IDX==k,3)-C(k))>thres_time)
            if max(temp(IDX==k,3))-min(temp(IDX==k,3))>thres_time
                flag = 0;
                centers = centers + 1;
                break
            end
        end
        if flag
            r = [];
            w = [];
            t = [];
            for l=1:length(C)
                if length(temp(IDX==l,1)) > 1
                    M = temp(IDX==l,:);
%                     if sum(M(:,1)==1) && sum(M(:,1)==3)
%                         if M(M(:,1)==1,2) > M(M(:,1)==3, 2)
%                             M(M(:,1)==1,2) = M(M(:,1)==1,2)-M(M(:,1)==3,2);
%                             M(M(:,1)==3,:) = [];
%                         else
%                             M(M(:,1)==3,2) = M(M(:,1)==1,2)-M(M(:,1)==3,2);
%                             M(M(:,1)==1,:) = [];
%                         end
%                     end
                    [val, loc] = max(temp(IDX==l,2));
                    loc = M(:,2)>=val-val*0.01;
                    r = [r; M(loc, 1)];
                    w = [w; M(loc, 2)];
                    t = [t; M(loc, 3)];
                else
                    r = [r; temp(IDX==l,1)];
                    w = [w; temp(IDX==l,2)];
                    t = [t; temp(IDX==l,3)];
                end
            end
            break
        end
    end
    for i=1:length(members)
        members{i} = [w(r==i), t(r==i)];
    end
            
    %% final detected result
    % format: event type = [root index, weight, time]
    gt = members{1};
    lt = members{2};
    ls = members{3};
    disp('gt'); disp(gt)
    disp('lt'); disp(lt)
    disp('ls'); disp(ls)
    if debug
        hold on
        n_bus = 1;
        xlim([301*(n_bus-1)+1,301*n_bus]);
        title_str = strcat( title_str, {': '}, ...
                            'Valley-', num2str(size(gt,1)), {', '}, ...
                            'Plain-', num2str(size(lt,1)), {', '}, ...
                            'Hill-', num2str(size(ls,1)) );
        title(title_str)
        if saveplot
            saveas(f0,strcat('Plots\best\', files(loop).name,'_0.bmp'),'bmp');
        end
        keydown = waitforbuttonpress;
        if (keydown == 0)
            %disp('Mouse button was pressed');
            close all
        else
            %disp('Key was pressed');
            close all
%             break
        end
    end
    
    %% output results
    if showplot
    setfontsize = 16;
    % Sparse coefficient
    f1 = figure;
    MyColor = rand(sum(TypeNum), 3);              
    for i=1:sum(TypeNum)
        markid = i*TimeSpan;
        hold on;
        plot([(i-1)*TimeSpan+1,markid], [0,0], 'color', MyColor(i,:), ...
             'LineWidth',3); 
        text(markid-round(TimeSpan*0.5), 0, [num2str(i)], ...
             'Color', [1,0,0], 'FontSize', setfontsize);
    end
    for i=1:sum(TypeNum)
        markid = i*TimeSpan;    
        hold on
        plot([markid, markid], [0.01, -0.01], 'r', 'LineWidth', 2);
    end
    hold on
    stem(id, id_gray, 'k', 'LineWidth', 2); 
    xlim([id(1)-round(id(end)*0.05), id(end)+round(id(end)*0.05)]);
    hold on 
    plot( id(1)-round(id(end)*0.05):id(end)+round(id(end)*0.05), ...
          thres_rate*ones(1, length(id(1)-round(id(end)*0.05):id(end)+...
          round(id(end)*0.05))), '--r', 'LineWidth', 2 )
    title('sparse coefficient', 'FontSize', setfontsize); 
    xlabel('index in dictionary', 'FontSize', setfontsize); 
    set(gca,'FontSize',setfontsize);
    for i=1:length(id)
        text( id(i)+0.2, id_gray(i), ...
              ['time:',num2str(id_time(i)*step*stream_during/stream_length+1),'s'],...
              'FontSize', 10 );
    end
    % save plots
    if saveplot
        saveas(f1,strcat('Plots\', files(loop).name,'_1.bmp'),'bmp');
    end
    end
    
    %% calculate statistic results
    if isempty(gt) time_gt = []; else time_gt = gt(:,2); end
    if isempty(lt) time_lt = []; else time_lt = lt(:,2); end
    if isempty(ls) time_ls = []; else time_ls = ls(:,2); end
    result_metrics = {time_gt, time_lt, time_ls};
    events_metrics = {'gt','lt','ls'};
    [Det, G] = dataconverter (files(loop).name, result_metrics, events_metrics);
    Detect = [Detect;Det];
    Ground = [Ground;G];
%     if sum(abs((Det(:,1:5)>=0)-(G>=0))>thres_time)>0
%         figure(loop)
%     end
    
end
close all
t = thres_time;
% detection accuracy
Accuracy = accuracy(Detect, Ground, events_metrics, t)
% false alarm rate
FalsRate = falserate( Detect, Ground, events_metrics, t)
% root-pattern recognition rate (R-P Recog)
RPR = RPRecog( Detect, Ground, events_metrics, t)
% occurrence time deviation
OTD = OTDelay( Detect, Ground, events_metrics, t)

% loose metrics
Accuracy_L = accuracy_loose(Detect, Ground, events_metrics, t)
FalsRate_L = falserate_loose( Detect, Ground, events_metrics, t)
% OTD_L = OTDelay_loose( Detect, Ground, events_metrics, t)
miss = length(files) - size(Detect,1)/3
%% plot the results
% plot_endmembers
% plot_reconstruct


