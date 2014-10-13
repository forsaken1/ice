require 'gruff'
require './lib.rb'

if ARGV.count == 2
  filename = ARGV.pop
  n = ARGV.pop.to_i
  x = get_x_from_file(filename)
  p_i = get_p_i(x)
else
  n = ARGV.first.to_i
  x = get_x(n)
  p_i = get_p_i(x)
end

#puts p_i
p 'Мат. ожидание: ' + math_expectation(x, p_i).to_s
p 'Дисперсия: ' + disp(x, p_i).to_s
p 'Коэффициент ассиметрии: ' + coeff_asym(x, p_i).to_s
p 'Коэффициент эксцесса: ' + excess(x, p_i).to_s

create_gyst(x, p_i)