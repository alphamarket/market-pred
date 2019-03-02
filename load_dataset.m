if(exist('dataset.dat', 'file'))
  fprintf('Loading cached dataset');
  dataset = importdata('dataset.dat');
  fprintf(' [DONE]\n');
else
  dataset = { };
  files = dir('data/csv/*.csv');
  for i=1:length(files)
    warning('OFF', 'MATLAB:table:ModifiedVarnames')
    fprintf('(%.1f%%) Reading file: `%s`', i / length(files) * 100, files(i).name)
    d = readtable(sprintf('data/csv/%s', files(i).name));
    dataset{end+1} = [d.x_FIRST_, d.x_LAST_, d.x_HIGH_, d.x_LOW_, d.x_VOL_];
    warning('ON', 'MATLAB:table:ModifiedVarnames')
    fprintf(' [DONE]\n')
  end
  clear files i d
  fprintf('Caching dataset to `dataset.dat` file')
  save('dataset.dat', 'dataset')
  fprintf(' [DONE]\n');
end