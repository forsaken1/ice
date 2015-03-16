# experiments count, length
# arguments: experiments count, length l
srand
$a = Float(1)
width = 2 * $a
$l = ARGV.size == 2 ? ARGV.last.to_f : rand($a/2...width)
times = ARGV.first.nil? ? [100, 1_000, 10_000, 100_000, 1_000_000] : [ARGV.first.to_i]
p_a = (2 * $l) / ($a * Math::PI)

def experiment
  x = rand(0..$a)
  fi = rand(0..Math::PI)
  (x <= $l * Math.sin(fi)) ? 1 : 0 # x <= l sin(fi)
end

puts "Width = 2; l = #{$l}; P(A) = #{Float(p_a)}\n"

times.each do |i|
	success_experiments_count = 0
	iter = 0
	while iter <= i
		success_experiments_count += experiment
		iter += 1
	end
  puts "Experiments count: #{i}\n"
  puts "Experimental P(A) = #{Float(success_experiments_count) / Float(i)}"
  puts "\n"
end
