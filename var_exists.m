function out = var_exists(var)
  out = evalin( 'base', sprintf('exist(''%s'', ''var'') == 1', var));
end

