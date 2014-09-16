def fact(n)
  result = Float(1)
  (1..n).each { |i| result *= i }
  result
end

def combination(m, n) # сочетания из n по m
  fact(n) / ( fact(m) * fact(n - m) )
end

def calc(_m, _n, m, n)
  ( combination(m, _m) * combination(n - m, _n - _m) ) / combination(n, _n)
end

arr = []
i = 0
while i <= 20
  arr << calc(20, 100, i, 20)
  p "p(#{i}) = " + arr.last.to_s
  i += 1
end

p "sum p_i = " + arr.inject(0) { |sum, x| sum + x }.to_s