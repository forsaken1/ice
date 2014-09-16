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

p p_i
p math_expectation(x, p_i)
p disp(x, p_i)
p coeff_asym(x, p_i)
p excess(x, p_i)

create_gyst(x, p_i)