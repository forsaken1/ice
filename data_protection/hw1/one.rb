require '../lib/lib.rb'

def encode(data)
  encode_str = ''
  pattern = ''
  sequence = false
  start = true
  i = 0
  cnt = 0

  while i < data.length
    current_char = data[i]
    next_char = data[i + 1]

    if current_char == next_char
      if sequence
        pattern = current_char
        #encode_str += "#{cnt+1}#{pattern}" if i + 1 == data.length
      else
        sequence = true
        unless start
          encode_str += "-#{cnt}#{pattern}"
          cnt = 0
          pattern = ''
          next
        end
      end
    else
      if sequence
        encode_str += "#{cnt}#{pattern}"
        cnt = 0
        pattern = ''
        sequence = false
        next
      else
        pattern += current_char
        #encode_str += "-#{cnt+1}#{pattern}" if i + 1 == data.length
      end
    end

    cnt += 1
    i += 1
    start = false
  end
  encode_str
end

print 'tests: '
print encode('') == '' ? '+' : '-'
print encode('wwwwwwrrrrrrrrgggggggggg') == '6w8r10g' ? '+' : '-'
print encode('ertertertffff') == '-9ertertert4f' ? '+' : '-'
print encode('tffff') == '-1t4f' ? '+' : '-'
print encode('tfffft') == '-1t4f-t' ? '+' : '-'
print encode('eeeertttt') == '4e1r4t' ? '+' : '-'
print encode('eeeerthgjf') == '4e-6rthgjf' ? '+' : '-'
print "\n"

init("Run-length encoding") { |text| encode(text) }