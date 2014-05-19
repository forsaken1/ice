require '../lib/lib.rb'

include Enumerable

def parse_str(str, ret = false)
  dec = ['+', '-', '*', '/', '^', ')']
  level = 0
  i = 0
  s = str.split('')
  lvls = []
  ts = []

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
      return 'unexpected sym'
    end
    lvls << level
    i += 1
  end

  if ret
    return [ts, lvls]
  else
    return ts
  end
end

def execute(a, sign, b)
  if sign == '+'
    a + b
  elsif sign == '-'
    a - b
  elsif sign == '*'
    a * b
  elsif sign == '/'
    a / b
  else
    a ** b
  end
end

def encode(data)
  ts, lvls = parse_str(data, true)

  if lvls[lvls.length - 1] != 1
    'unbalanced expression'
  else
    while ts.length != 1
      i = lvls[lvls.max]
      if (ts[i - 1] != '(' or ts[i + 3] != ')')
        return 'not enough bracket'
      end
      ts[i - 1...i + 4] = [ execute(ts[i], ts[i + 1], ts[i + 2]) ]
      lvls[i - 1...i + 4] = [ lvls[i + 1] ]
    end
    ts[0].to_s
  end
end

init("Run-length encoding") { |text| encode(text) }