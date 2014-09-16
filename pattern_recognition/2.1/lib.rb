def fact(n) # факториал
  result = Float(1)
  (1..n).each { |i| result *= i }
  result
end

def combination(m, n) # сочетания из n по m
  fact(n) / ( fact(m) * fact(n - m) )
end

def calc(_m, _n, m, n) # выборка n единиц с m объектов определенного качества из N объектов с M единиц особого качества
  ( combination(m, _m) * combination(n - m, _n - _m) ) / combination(n, _n)
end

def math_expectation(x, p_i) # мат.ожидание
  result = 0
  x.each_with_index { |item, i| result += item * p_i[i] }
  result
end

def disp(x, p_i) # дисперсия
  m_e = math_expectation(x, p_i)
  result = 0
  x.each_with_index { |item, i| result += p_i[i] * (item ** 2)  }
  result - (m_e ** 2)
end

def deviation(x, p_i) # квадратическое отклонение
  Math.sqrt(disp(x, p_i))
end

def center_moment(q, x, p_i) # центральный момент q-го порядка
  result = 0
  m_e = math_expectation(x, p_i)
  x.each_with_index { |item, i| result += ( (item - m_e) ** q ) * p_i[i] }
  result
end

def coeff_asym(x, p_i) # коэффициент асимметрии
  center_moment(3, x, p_i) / ( deviation(x, p_i) ** 3)
end

def excess(x, p_i) # коэффициент эксцесса
  center_moment(4, x, p_i) / ( deviation(x, p_i) ** 4) - 3
end

# ------

def get_x_from_file(filename) # построчно
  x = []
  fileObj = File.new(filename, "r")
  while (line = fileObj.gets)
    x << line.to_i
  end
  fileObj.close
  x
end

def get_x(n)
  x = Array.new(n + 1) { |i| i += 1; i - 1 } # [0, .., n]
end

def get_p_i(x)
  p_i = []
  x.each_with_index { |item, i| p_i << calc(20, 100, item, x.count - 1) } # -1 так как первый элемент = 0
  p_i
end

# ------

def create_gyst(x, p_i)
  g = Gruff::Bar.new 500
  g.title = 'Гистограмма распределения Х'
  g.hide_legend = true
  g.marker_font_size = 18
  g.theme = {
    :colors => ['#aedaa9', '#12a702'],
    :marker_color => '#dddddd',
    :font_color => 'black',
    :background_colors => 'white'
  }
  g.data 'Savings', p_i
  g.labels = x.inject({}) { |memo, index| { index => index.to_s }.merge(memo) }
  g.maximum_value = 1
  g.minimum_value = 0
  g.write('gyst.png')
end