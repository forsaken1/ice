require 'gtk2'

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

def get_text(tw)
  start_iter, end_iter, selected  = tw.buffer.selection_bounds

  if !selected
    start_iter, end_iter = tw.buffer.bounds
  end
  tw.buffer.get_text(start_iter, end_iter)
end

def insert_text(text_out, text)
  text_out.buffer.text = (text)
end

def init(title)
  window = Gtk::Window.new
  window.set_title(title)
  window.border_width = 10
  window.resizable = true
  window.set_size_request(600, 300)

  text_in = Gtk::TextView.new
  text_out = Gtk::TextView.new

  button = Gtk::Button.new("Encode")
  button.signal_connect("clicked") do
    text = get_text(text_in)
    insert_text(text_out, yield(text))
  end

  hbox = Gtk::HBox.new(false, 5)
  hbox.pack_start_defaults(button)
  vbox = Gtk::VBox.new(false, 5)
  vbox.pack_start(text_in,  true,  true, 0)
  vbox.pack_start(text_out, true,  true, 0)
  vbox.pack_start(hbox,     false, true, 0)

  window.signal_connect("delete_event") do
    false
  end

  window.signal_connect("destroy") do
    Gtk.main_quit
  end

  window.add(vbox)
  window.show_all

  Gtk.main
end