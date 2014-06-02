require '../lib/lib.rb'
require '../lib/gtk.rb'

def parse_str(str)
  dec, lvls, ts = ['+', '-', '*', '/', '^', ')'], [], []
  level, i = 0, 0
  s = str.delete(' ').split('')
  raise '' unless s.length > 0

  while i < s.length
    if dec.include?(s[i])
      ts << s[i]
      level -= 1
    elsif s[i] == '('
      ts << s[i]
      level += 1
    elsif '0' <= s[i] && s[i] <= '9'
      level += 1
      j = i
      ns = ''
      while '0' <= s[j] && s[j] <= '9' && j < s.length
        ns << s[j]
        j += 1
      end
      i = j - 1
      ts << ns.to_i
    else
      raise 'Unexpected symbol'
    end
    lvls << level
    i += 1
  end
  [ts, lvls]
end

def encode(data)
  begin
    ts, lvls = parse_str(data)
  rescue => error
    return error.to_s
  end

  if lvls.last != 1
    'Unbalanced expression'
  else
    while ts.length != 1
      i = lvls[lvls.max]
      if ts[i - 1] != '(' or ts[i + 3] != ')'
        return 'Not enough bracket'
      end
      ts[i - 1..i + 3] = [ execute(ts[i], ts[i + 1], ts[i + 2]) ]
      lvls[i - 1..i + 3] = [ lvls[i + 1] ]
    end
    ts.first.to_s
  end
end

test_case do
  errors = ''
  errors << test('', '') { |e| encode(e) }
  errors << test('(1 + 2)', '3') { |e| encode(e) }
  errors << test('(11 + 22)', '33') { |e| encode(e) }
  errors << test('(3 - 5)', '-2') { |e| encode(e) }
  errors << test('(7 * 7)', '49') { |e| encode(e) }
  errors << test('(100 / 10)', '10') { |e| encode(e) }
  errors << test('(2 ^ 10)', '1024') { |e| encode(e) }
  errors << test('((11 + 22) * 3)', '99') { |e| encode(e) }
  errors << test('((3 * 8) + 4)', '28') { |e| encode(e) }
  errors << test('(((5 ^ 3) - 25) / 10)', '10') { |e| encode(e) }
  errors << test('((7 + 7))', 'Not enough bracket') { |e| encode(e) }
  errors << test('(1 3)', 'Not enough bracket') { |e| encode(e) }
  errors << test('(1+)', 'Unbalanced expression') { |e| encode(e) }
  errors << test('(7 * 7))', 'Unbalanced expression') { |e| encode(e) }
  errors << test('(7 ** 7)', 'Unbalanced expression') { |e| encode(e) }
  errors << test('(7 ~ 7)', 'Unexpected symbol') { |e| encode(e) }
  errors << test('№', 'Unexpected symbol') { |e| encode(e) }
end

init("@Рутисхаузера") { |text| encode(text) }