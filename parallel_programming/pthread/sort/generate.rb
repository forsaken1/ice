srand

File.open('array.txt', 'w') do |file|
  10000.times { file.puts rand(1000).to_s }
end