require '../lib/lib.rb'

def encode(data)
  encode_str = ''
  i = 0

  while i < data.length
    smb = data[i]
    cnt = 1
    j = i
    while j < data.length
      if data[j + 1] != smb.to_s
        break
      end
      cnt += 1
      i += 1
      j += 1
    end
    encode_str += cnt.to_s + smb.to_s
    i += 1
  end
  encode_str
end

init("Run-length encoding") { |text| encode(text) }