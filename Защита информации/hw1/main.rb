require '../lib/lib.rb'

def encode(data)
  prev = result = ''
  counter = 1

  data.each_char do |e|
    if e == prev
      counter += 1
    else
      result += counter.to_s + prev if prev != ''
      counter = 1
    end
    prev = e
  end
  result
end

init("Run-length encoding") { |text| encode(text) }