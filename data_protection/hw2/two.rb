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
  s = data
  t, e = ['#'], []
      
  table = [
    [6,1,1,1,5],
    [5,1,1,1,3],
    [4,1,2,1,4],
    [4,1,4,2,4],
  ]

  loops = true
  i = 0

  begin 
    while loops
      if i < s.length
        cur = s[i]
      else
        cur = '#'
      end

      i += 1

      if '0' <= cur && cur <= '9'
        e << cur
        next
      end

      if sign_code(cur) == INF
        return 'Unexpected symbol'
      end

      flag = true

      while flag
        flag = false
        case table[ sign_code( t[t.length - 1] ) ][ sign_code(cur) ]
        when 1 then t << cur
        when 2 then
          b = e.pop
          a = e.pop
          e << execute(a.to_i, t.pop, b.to_i)
          t << cur
        when 3 then t.pop
        when 4 then
          b = e.pop 
          a = e.pop
          e << execute(a.to_i, t.pop, b.to_i)
          flag = true
        when 5 then return 'Error'
        when 6 then loops = false
        end
      end
    end
  rescue Exception
    return 'Error'
  end
  e[0].to_s
end

init("@Бауера-Замельзона") { |text| encode(text) }