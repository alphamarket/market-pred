if(exist('caches/dataset.dat', 'file'))
  fprintf('Loading cached dataset');
  dataset = importdata('caches/dataset.dat');
  fprintf(' [DONE]\n');
else
  dataset = { };
  lastsize = 0;
  files = dir('data/csv/*.csv');
  for i=1:length(files)
    warning('OFF', 'MATLAB:table:ModifiedVarnames')
    fprintf(repmat('\b', 1, lastsize));
    lastsize = fprintf('(%.1f%%) Reading file: `%s`', i / length(files) * 100, files(i).name);
    d = readtable(sprintf('data/csv/%s', files(i).name));
    dataset{end+1} = [d.x_OPEN_, d.x_HIGH_, d.x_LOW_, d.x_CLOSE_, d.x_VOL_];
    warning('ON', 'MATLAB:table:ModifiedVarnames')
  end
  clear files i d
  fprintf(repmat('\b', 1, lastsize));
  fprintf('Caching dataset to `dataset.dat` file')
  save('caches/dataset.dat', 'dataset')
  fprintf(' [DONE]\n');
end