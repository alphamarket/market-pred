fprintf('Preprocessing the dataset')
% the gain set of the dataset
gainset = { };
% for each set
for set=1:length(dataset)
  % ignore datasets with one or zero values
  if(size(dataset{set}, 1) < 2)
    continue
  end
  % get the data
  data = dataset{set};
  % calc the gain ratio of the dataset
  gainset{end+1} = (data(1:end-1, :) ./ data(2:end, :)) - 1;
  % a fail-check for correct calculations
  assert(isequal((data(end-1, :) ./ data(end, :)) - 1, gainset{end}(end, :)))
end
clear data set
fprintf(' [DONE]\n')