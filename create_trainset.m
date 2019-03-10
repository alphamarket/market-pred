function trainset = create_trainset(gainset, periods)
  if var_exists('trainset')
    disp('The `trainset` already exists in workspace [No need to reload!].');
    trainset = evalin('base', 'trainset');
    return
  elseif(exist('caches/trainset.dat', 'file'))
    fprintf('Loading cached trainset');
    trainset = importdata('caches/trainset.dat');
    fprintf(' [DONE]\n');
  else
    fprintf('Creating the trainset')
    lastsize = 0;
    trainset = { };
    for set=1:length(gainset)
      gset = gainset{set};
      if(size(gset, 1) < max(periods) + 1)
        continue
      end
      trainset{end + 1} = struct;
      for m = 1:length(periods)
        eval(sprintf('trainset{end}.m%i = { };', periods(m)));
      end
      for col=1:size(gset, 2)
        fprintf(repmat('\b', 1, lastsize))
        lastsize = fprintf(' — %.1f%% of data is getting processed. [step %i of %i]', set / length(gainset) * 100, col, size(gset, 2)); 
        for m = 1:length(periods)
          eval(sprintf('trainset{end}.m%i{end + 1} = [];', periods(m)));
        end
        for idx=(max(periods) + 1):length(gset)
          for m = 1:length(periods)
            eval(sprintf('trainset{end}.m%i{end} = [trainset{end}.m%i{end}; gset(idx - %i:idx - 1, col)'', gset(idx, col)];', periods(m), periods(m), periods(m)));
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
end