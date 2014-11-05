def test_case
  print 'Tests: '
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
    p res
    "Error: #{question} != #{answer}, but: #{res}\n"
  end
end

def execute(a, sign, b)
  case sign
  when '+' then a + b
  when '-' then a - b
  when '*' then a * b
  when '/' then a / b
  when '^' then a ** b
  else
    'Unknown sign'
  end
end