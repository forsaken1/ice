def mult_by_range(m, n)
  result = Float(1)
  (m..n).each { |i| result *= i }
  result
end

arr = []
i = 0
while i <= 20
  arr << ( mult_by_range(61 + i, 80) * mult_by_range(21 - i, 20) ) / mult_by_range(81, 100)
  i += 1
end

p arr