require '../lib/lib.rb'
require '../lib/gtk.rb'

ROUND = 5
 
def encode(data, pattern = data)
  seq, lit = {}, {}
  left, right = 0, 1

  data.each_char { |e| seq[e] = Float(data.count(e)).round(ROUND) / data.length }
  seq.sort { |a, b| b[1] <=> a[1] }
  	.each { |e| lit[e[0]] = [left.round(ROUND), Float(e[1] + left).round(ROUND)]; left += e[1] }
  
  new_left, new_right = lit[pattern[0]][0], lit[pattern[0]][1]
  result = []
  
  pattern.each_char do |e|
  	new_rl = [new_left + (new_right - new_left) * Float(lit[e][0]), 
  			  		new_left + (new_right - new_left) * Float(lit[e][1])]
  	new_left, new_right = new_rl[0], new_rl[1]
  	result << new_rl
  end
  result.last.last.to_s
end

print encode("ABCDB", "ABCDB"), "\n"

init("Arithm. encoding") { |text| encode(text) }