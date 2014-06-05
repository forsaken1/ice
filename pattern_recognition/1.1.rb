srand
max_digit = 36
operations_count = ARGV.first.to_i

[100, 1_000, 10_000, 100_000, 1_000_000].each do |i|
  iter = 0
  player_table = Array.new(36) { |it| it + 1 }
  selected = Array.new(100) { |it| rand(player_table.size) }.uniq[0..4]
  result = Array.new(3) {0}

  while iter <= i do
    player_choise = Array.new(100) { |it| rand(player_table.size) }.uniq[0..4]
    result[0] += 1 if (player_choise & selected).size == 3
    result[1] += 1 if (player_choise & selected).size == 4
    result[2] += 1 if (player_choise & selected).size == 5
    iter += 1
  end
  puts "#{i}:"
  puts result.map { |item| "#{Float(item) / i * 100}%" }
  puts "\n"
end