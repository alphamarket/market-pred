function module = train_dataset(tset) %#ok<INUSD>
  fprintf('Training the trainset...\n');
  portions = [1, 3, 7, 14, 28, 56, 112, 224];
  module = struct;
  for i=1:length(portions)
    if(exist(sprintf('caches/nets-m%i.dat', portions(i)), 'file'))
      fprintf('[SKIP] Skipping the m-%i, because of it''s cache exists!\n', portions(i))
      continue;
    end
    fprintf('Executing the train for m-%i...\n', portions(i));
    eval(sprintf('module.m%i = train_m(tset, %i);', portions(i), portions(i)));
  end
  save('caches/train-modules.dat', 'module')
  fprintf('All training modules trained! [DONE]\n')
end

function [nets, perf, infs] = train_m(set, m) %#ok<*DEFNU>
  last_size = 0;
  nets = { };
  eval(sprintf('len = size(set{1}.m%i, 2);', m));
  for col = 1:len
    nets{end + 1} = build_network(m);
  end
  perf = cell(1, length(set{1}.m1));
  infs = zeros(1, length(perf));
  for ddx = 1:length(set)
    eval(sprintf('data = set{ddx}.m%i;', m));
    % for all trainset
    for col = 1:length(data) %#ok<USENS>
      sub_data = data{col};
      % get shuffled indices for randomise the trainset
      rdx = randperm(size(sub_data, 1));
      % pick input & output data
      x = sub_data(rdx, 1:m)';
      t = sub_data(rdx, m + 1)';
      % train the network
      [nets{col}, tr] = train(nets{col}, x, t, 'useParallel', 'yes');
      % store the preformace history
      if(abs(tr.best_perf) ~= Inf)
        perf{col} = [perf{col}; tr.best_perf];
      else
        infs(col) = infs(col) + 1;
      end
      % print the progress
      % fprintf(repmat('\b', 1, last_size));
      last_size = fprintf('» %.2f%% | %i of %i | Best perf.: %f | Avg. perf.: %f | Inf#: %i\n\n', ddx * 100 / length(set), col, length(data), tr.best_perf, mean(perf{col}), infs(col));
    end
  end
  save(sprintf('caches/nets-m%i.dat', m), 'nets', 'perf', 'infs')
  % print the completion
  fprintf(repmat('\b', 1, last_size));
  fprintf('Training the m-{%i} [DONE]', m)
end

function net = build_network(m)
  switch(m)
    case 1
      net = feedforwardnet(3);
    case 3
      net = feedforwardnet(7);
    case 7
      net = feedforwardnet(14);
    case 14
      net = feedforwardnet(28);
    case 28
      net = feedforwardnet(56);
    case 56
      net = feedforwardnet(112);
    case 112
      net = feedforwardnet(224);
    case 224
      net = feedforwardnet(448);
  end
end