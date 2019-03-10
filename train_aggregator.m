function aggergator = train_aggregator(trainset, train_module)
  aggergator = [];
  for idx = 1:length(trainset)
    fields = fieldnames(trainset{idx});
    input = struct;
    for field = 1:length(fields)
      eval(sprintf('input.%s = { };', fields{field}));
      for col = 1:length(eval(sprintf('trainset{idx}.%s', fields{field})))
        eval(sprintf('input.%s{end + 1} = [];', fields{field}));
      end
    end
    for field = 1:length(fields)
      for row = 1:length(eval(sprintf('trainset{idx}.%s{1}', fields{field})))
        pred = [];
        target = eval(sprintf('trainset{idx}.%s{1}(%i, end)', fields{field}, row));
        for col = 1:length(eval(sprintf('trainset{idx}.%s', fields{field})))
          pred(end + 1) = eval(sprintf('train_module.%s{%i}(trainset{idx}.%s{%i}(%i, 1:end-1)'')', fields{field}, col, fields{field}, col, row));
        end
      end
        pred = eval(sprintf('train_module.%s{%i}(trainset{idx}.%s{%i}(:, 1:end-1)'')', fields{field}, col, fields{field}, col));
        target = eval(sprintf('trainset{idx}.%s{%i}(:, end)', fields{field}, col));
        if(length(aggergator) < col)
          aggergator(end + 1) = feedforward(10);
        end
        train(aggergator(col), pred, target)
      end
    end
  end
  data = build_aggregator_dataset(trainset);
train_module
aggregator = 1;
end

function data = build_aggregator_dataset(trainset)
  data = struct;
  fprintf('Building Aggregator dataset')
  lastsize = 0;
  for idx = 1:length(trainset)
    fprintf(repmat('\b', 1, lastsize));
    lastsize = fprintf(' (%.2f%% done)', (idx - 1) * 100 / length(trainset));
    fields = fieldnames(trainset{idx});
    for col = 1:length(fields)
      if ~isfield(data, fields{col})
        eval(sprintf('data.%s = { };', fields{col}));
      end
      eval(sprintf('dd = trainset{idx}.%s;', fields{col}));
      while(length(eval(sprintf('data.%s', fields{col}))) < length(dd))
        eval(sprintf('data.%s{end + 1} = [];', fields{col}))
      end
      for ddx = 1:length(dd)
        eval(sprintf('data.%s{%i} = [data.%s{%i}; dd{ddx}];', fields{col}, ddx, fields{col}, ddx));
      end
    end
  end
  fprintf(repmat('\b', 1, lastsize));
  fprintf(' [DONE]\n');
end
