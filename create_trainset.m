if exist('trainset', 'var')
  disp('The `trainset` already exists in workspace [No need to reload!].');
  return
elseif(exist('caches/trainset.dat', 'file'))
  fprintf('Loading cached trainset');
  trainset = importdata('caches/trainset.dat');
  fprintf(' [DONE]\n');
else
  fprintf('Creating the trainset')
  lastsize = 0;
  trainset = { };
  map = [1, 3, 7, 14, 28, 56];
  for set=1:length(gainset)
    gset = gainset{set};
    if(size(gset, 1) < 57)
      continue
    end
    trainset{end + 1} = struct;
    for m = 1:length(map)
      eval(sprintf('trainset{end}.m%i = { };', map(m)));
    end
    for col=1:size(gset, 2)
      fprintf(repmat('\b', 1, lastsize))
      lastsize = fprintf(' — %.1f%% of data is getting processed. [step %i of %i]', set / length(gainset) * 100, col, size(gset, 2)); 
      for m = 1:length(map)
        eval(sprintf('trainset{end}.m%i{end + 1} = [];', map(m)));
      end
      for idx=57:length(gset)
        for m = 1:length(map)
          eval(sprintf('trainset{end}.m%i{end} = [trainset{end}.m%i{end}; gset(idx - %i:idx - 1, col)'', gset(idx, col)];', map(m), map(m), map(m)));
        end
      end
    end
    fprintf(repmat('\b', 1, lastsize));
    lastsize = fprintf(' (%.1f%% of data processed)', set / length(gainset) * 100);
  end
  save('caches/trainset.dat', 'trainset', '-v7.3')
  fprintf(repmat('\b', 1, lastsize));
  fprintf(' [DONE]\n');
  clear set idx lastsize gset col map m
end