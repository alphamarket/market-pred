function module = train_dataset(tset) %#ok<INUSD>
  fprintf('Training the trainset...\n');
  portions = [1, 3, 7, 14, 28, 56, 112, 224];
  module = struct;
  for i=1:length(portions)
    if(exist(sprintf('caches/nets-m%i.dat', portions(i)), 'file'))
      fprintf('[SKIP] Skipping the m-%i, because of it''s cache exists!\n', portions(i))
      tmp = importdata(sprintf('caches/nets-m%i.dat', portions(i))); %#ok<NASGU>
      eval(sprintf('module.m%i = tmp.nets;', portions(i)));
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
      % [nets{col}, tr] = train(nets{col}, x, t);
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
  fprintf('Training the m-{%i} [DONE]\n', m)
end

function net = build_network(m)
  switch(m)
    case 1
      net = feedforwardnet([m * 3, m * 2]);
    case 3
      net = feedforwardnet([m * 3, m]);
    case 7
      net = feedforwardnet([m * 4, m]);
    case 14
      net = feedforwardnet([m * 4, m / 2]);
    case 28
      net = feedforwardnet([m * 4, m]);
    case 56
      net = feedforwardnet([m * 4, m]);
    case 112
      net = feedforwardnet([m * 4, m]);
    case 224
      net = feedforwardnet([m, m * 2]);
  end
  net.trainFcn = 'trainrp';
  net.trainParam.goal = 1e-5;
  net.trainParam.epochs = 300;
  net.trainParam.max_fail = 3;
end