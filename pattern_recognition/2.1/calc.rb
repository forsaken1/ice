require './lib.rb'

x = Array.new(21) { |i| i += 1; i - 1 }
p_i = [] # массив вероятностей для случайной величины x, x = 0..20
i = 0
while i <= 20
  p_i << calc(20, 100, i, 20)
  #p "p(#{i}) = " + p_i.last.to_s
  i += 1
end

sum = [] # массив значений функции распределения
i = 0
while i <= 20
  sum << p_i[0..i].inject(0) { |sum, x| sum + x }
  #p "sum p_i = " + sum.last.to_s
  i += 1
end

check_p = p_i.inject(0) { |sum, x| sum + x } # проверка, что суммы всех вероятностей == 1

p check_p
p math_expectation(x, p_i)
p disp(x, p_i)