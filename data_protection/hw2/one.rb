require '../lib/lib.rb'

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