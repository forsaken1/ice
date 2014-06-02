require '../lib/lib.rb'
#require '../lib/gtk.rb'

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
    cnt += 1

    if next_char == nil
      encode_str += "#{cnt + 1}#{pattern}" if sequence
      encode_str += "-#{cnt}#{pattern+current_char}" unless sequence
    elsif current_char == next_char
      sequence = true if (data[i - 1] == data[i - 2]) && i > 1
      if sequence
        pattern = current_char
      else
        sequence = true
        unless start
          encode_str += "-#{cnt - 1}#{pattern}"
          cnt = 0
          pattern = ''
        end
      end
    else
      if sequence
        encode_str += "#{cnt}#{pattern}"
        cnt = 0
        pattern = ''
        sequence = false
      else
        pattern += current_char
      end
    end
    i += 1
    start = false
  end
  encode_str
end

test_case do
  errors = ''
  errors += test('wwwwwwrrrrrrrrgggggggggg', '6w8r10g') { |str| encode(str) }
  errors += test('ertertertffff', '-9ertertert4f') { |str| encode(str) }
  errors += test('tffff', '-1t4f') { |str| encode(str) }
  errors += test('tfffft', '-1t4f-1t') { |str| encode(str) }
  errors += test('eeeertttt', '4e-1r4t') { |str| encode(str) }
  errors += test('eeeerthgjf', '4e-6rthgjf') { |str| encode(str) }
  errors += test('wwwtttr', '3w3w-1r') { |str| encode(str) }
  errors += test('ntwww', '-2nt3w') { |str| encode(str) }
end

#init("Run-length encoding") { |text| encode(text) }