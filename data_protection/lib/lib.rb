def test_case
  print 'tests: '
  errors = yield
  print "\n"
  print errors
end

def test(question, answer)
  if (res = yield(question)) == answer
    print '+'
    ''
  else
    print '-'
    "Error: #{question} != #{answer}, but: #{res}\n"
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
      return 'Unexpected symbol'
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
