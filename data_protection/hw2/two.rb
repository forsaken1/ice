require '../lib/lib.rb'
require '../lib/gtk.rb'

INF = 1e6

def sign_code(char)
  case char 
  when '#' then 0
  when '(' then 1
  when ')' then 4
  else
    if ['+', '-'].include?(char)
      2
    elsif ['*', '/'].include?(char)
      3
    else
      INF
    end
  end
end

def encode(data)
  s = data.delete(' ')
  t, e = ['#'], []
  loops, i = true, 0
  table = [
    [6, 1, 1, 1, 5],
    [5, 1, 1, 1, 3],
    [4, 1, 2, 1, 4],
    [4, 1, 4, 2, 4],
  ]

  begin 
    while loops
      cur = i < s.length ? s[i] : '#'
      flag = true
      i += 1

      if '0' <= cur && cur <= '9'
        num = cur
        while s[i] != nil && '0' <= s[i] && s[i] <= '9' && i < s.length
          num << s[i]
          i += 1
        end
        e << num
        next
      end

      raise 'Unexpected symbol' if sign_code(cur) == INF

      while flag
        flag = false
        case table[ sign_code(t.last) ][ sign_code(cur) ]
        when 1 then
          t << cur
        when 2 then
          b, a = e.pop, e.pop
          raise 'Error' if a == nil || b == nil
          e << execute(a.to_i, t.pop, b.to_i)
          t << cur
        when 3 then
          t.pop
        when 4 then
          b, a = e.pop, e.pop
          raise 'Error' if a == nil || b == nil
          e << execute(a.to_i, t.pop, b.to_i)
          flag = true
        when 5 then 
          return 'Error'
        when 6 then 
          loops = false
        end
      end
    end
  rescue => error
    return error.to_s
  end
  e[0].to_s
end

test_case do
  errors = ''
  errors << test('', '') { |e| encode(e) }
  errors << test('1 + 2', '3') { |e| encode(e) }
  errors << test('11 + 22', '33') { |e| encode(e) }
  errors << test('1000000 + 2000000', '3000000') { |e| encode(e) }
  errors << test('3 - 5', '-2') { |e| encode(e) }
  errors << test('7 * 7', '49') { |e| encode(e) }
  errors << test('5 / 5', '1') { |e| encode(e) }
  errors << test('100 / 10', '10') { |e| encode(e) }
  errors << test('(11 + 22) * 3', '99') { |e| encode(e) }
  errors << test('(3 * 8) + 4', '28') { |e| encode(e) }
  errors << test('((5 * 3) + 25) / 10', '4') { |e| encode(e) }
  errors << test('((7 + 7))', '14') { |e| encode(e) }
  errors << test('1+', 'Error') { |e| encode(e) }
  errors << test('7 * 7)', 'Error') { |e| encode(e) }
  errors << test('7 ** 7', 'Error') { |e| encode(e) }
  errors << test('7 ~ 7', 'Unexpected symbol') { |e| encode(e) }
  errors << test('№', 'Unexpected symbol') { |e| encode(e) }
end

init("@Бауера-Замельзона") { |text| encode(text) }