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
  trainset.m1 = { };
  trainset.m3 = { };
  trainset.m7 = { };
  trainset.m14 = { };
  trainset.m28 = { };
  trainset.m56 = { };
  for set=1:length(gainset)
    gset = gainset{set};
    if(size(gset, 1) < 57)
      continue
    end
    for col=1:size(gset, 2)
      trainset.m1{end + 1} = [];
      trainset.m3{end + 1} = [];
      trainset.m7{end + 1} = [];
      trainset.m14{end + 1} = [];
      trainset.m28{end + 1} = [];
      trainset.m56{end + 1} = [];
      for idx=57:length(gset)
        trainset.m1{end} = [trainset.m1{end}; gset(idx - 1, col), gset(idx, col)];
        trainset.m3{end} = [trainset.m3{end}; gset(idx - 3:idx - 1, col)', gset(idx, col)];
        trainset.m7{end} = [trainset.m7{end}; gset(idx - 7:idx - 1, col)', gset(idx, col)];
        trainset.m14{end} = [trainset.m14{end}; gset(idx - 14:idx - 1, col)', gset(idx, col)];
        trainset.m28{end} = [trainset.m28{end}; gset(idx - 28:idx - 1, col)', gset(idx, col)];
        trainset.m56{end} = [trainset.m56{end}; gset(idx - 56:idx - 1, col)', gset(idx, col)];
      end
    end
    fprintf(repmat('\b', 1, lastsize));
    lastsize = fprintf(' (%.1f%% of data processed)', set / length(gainset) * 100);
  end
  save('caches/trainset.dat', 'trainset', '-v7.3')
  fprintf(repmat('\b', 1, lastsize));
  fprintf(' [DONE]\n');
  clear set idx lastsize gset col
end