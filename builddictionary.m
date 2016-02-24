function [ Signature, TypeNum, Sc, Tc ] = builddictionary( ...
                                            stream_length, roots, trivial )
% use trivial under default
if nargin < 3 
    trivial = 0;
end

%% keep all roots the same length 
scale = cellfun('length',roots);
max_scale = max(scale);
if length(roots{1}) == max_scale
    root_pattern_gen  = roots{1};
else
    root_pattern_gen  = [roots{1}; repmat(roots{1}(end,:), ...
                                          max_scale-length(roots{1}),1)];
end
if length(roots{2}) == max_scale
    root_pattern_line = roots{2};
else
    root_pattern_line = [roots{2}; repmat(roots{2}(end,:), ...
                                          max_scale-length(roots{2}),1)];
end
if length(roots{3}) == max_scale
    root_pattern_load = roots{3};
else
    root_pattern_load = [roots{3}; repmat(roots{3}(end,:), ...
                                          max_scale-length(roots{3}),1)];
end
Endmember = [root_pattern_gen, root_pattern_line, root_pattern_load];
TypeNum   = [size(root_pattern_gen, 2), size(root_pattern_line, 2), ...
             size(root_pattern_load, 2)];

%% build a variational dictionary 
Endmember = Endmember - repmat(Endmember(1,:), size(Endmember,1), 1);
[nr,nc] = size(Endmember);
if stream_length < nr
    %fprintf('stream length is smaller than signature length, mistake\n');
    %error('Stream length is smaller than signature length');
    Endmember = Endmember(1:stream_length, :);
else
    Endmember = [Endmember; repmat(Endmember(end,:),stream_length-nr,1)];
end
Signature = [];
% shift step
step = 2;
for i=1:nc
    vectemp = Endmember(:,i);
    % shift untile 15s is left
    for j=1:step:(stream_length-15/0.1)
        sigtemp = vectemp;
        sigtemp(1:j) = sigtemp(1);
        sigtemp(j:end) = vectemp(1:end-j+1);
        Signature = [Signature, sigtemp];
    end
end
% for i=1:nc
%     vectemp = Endmember(:,i);
%     for j=1:step:(stream_length-nr+1)
%         sigtemp = zeros(stream_length,1);
%         sigtemp(j:nr+j-1) = sigtemp(j:nr+j-1) + vectemp;
%         sigtemp(nr+j:end) = vectemp(end);
%         Signature = [Signature, sigtemp];
%     end
% end
Sc = size(Signature,2);

%% build trivial signals
Tc = 0;
Tuple = [];
if trivial
    % width of trival signal 
    span = 6;
    for i=1:span:stream_length-span+1
        sigtemp = zeros(stream_length,1);
        sigtemp([i:i+(span-1)]) = 1;
        Tuple = [Tuple, sigtemp];
        sigtemp = -1*sigtemp;
        Tuple = [Tuple, sigtemp];
    end
    Tc = size(Tuple,2);
end
Signature = [Signature, Tuple];
% normalization
ratio = min(1./abs(max(Signature)), 1./abs(min(Signature)));
Signature = Signature * diag(ratio);
%fprintf('Dictionary building finished\n');

end

