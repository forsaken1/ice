srand
iter = 0
max_digit = 99
operations_count = 10000
player_table = Array.new(max_digit) { |i| i = rand(max_digit) }.uniq[0..35]
result = Array.new(3) { |i| i = 0 }

while iter <= operations_count do
  puts (iter += 1).to_s + ' is ' + operations_count.to_s
  player_choise  = Array.new(10) { |i| i = player_table[rand(player_table.size)] }.uniq[0..4]
  selected = Array.new(10) { |i| i = player_table[rand(player_table.size)] }.uniq[0..4]
  result[0] += 1 if (player_choise & selected).size == 5
  result[1] += 1 if (player_choise & selected).size == 4
  result[2] += 1 if (player_choise & selected).size == 3
end

puts result.map { |item| item = (Float(item) / operations_count * 100).to_s + ' %' }