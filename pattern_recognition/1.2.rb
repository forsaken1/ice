srand

def experiment
  x = rand(0..a)
  fi = rand(0..Math::PI)

  (x <= l * Math.sin(fi)) ? 1 : 0 # x <= l sin(fi)
end

success_count = 0
operations_count = ARGV.first.to_i
a = 1
width = 2 * a
l = rand(a/2...width)

[1_000_000].each do |i|
  unless operations_count == 0
    break if i > operations_count
  end

  success_count += experiment()
end

p "Success: #{success_count} of #{operations_count}"