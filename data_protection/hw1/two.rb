require '../lib/lib.rb'
require '../lib/gtk.rb'

ROUND = 5
 
def encode(data)
  seq = {}
  lit = {}
  data.each_char { |e| seq[e] = Float(data.count(e)).round(ROUND) / data.length }
  seq.sort { |a, b| b[1] <=> a[1] }.each { |e| lit[e[0]] = e[1] }
  lit
end

print encode("ABCDB"), "\n"

#init("Arithm. encoding") { |text| encode(text) }