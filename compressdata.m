function [compressed] = compressdata(originaldata, target)

m = length(originaldata);
rate = round(m/target);
compressed = [];
for i=1:rate:m
    compressed = [compressed;originaldata(i,:)];
end

end
    