#!/usr/bin/ruby

require 'gtk2'

def get_text(tw)
  start_iter, end_iter, selected  = tw.buffer.selection_bounds

  if !selected
    start_iter, end_iter = tw.buffer.bounds
  end
  tw.buffer.get_text(start_iter, end_iter)
end

def insert_text(txtvu, text)
  mark = txtvu.buffer.selection_bound
  iter = txtvu.buffer.get_iter_at_mark(mark)
  txtvu.buffer.insert(iter, text)
end

def encode(data)
  prev = result = ''
  counter = 1

  data.each_char do |e|
    if e == prev
      counter += 1
    else
      result += counter.to_s + prev if prev != ''
      counter = 1
    end
    prev = e
  end
  result
end

window = Gtk::Window.new
window.set_title("Run-length encoding")
window.border_width = 10
window.resizable = true
window.set_size_request(600, 300)

text_in = Gtk::TextView.new
text_out = Gtk::TextView.new

button = Gtk::Button.new("Encode")
button.signal_connect("clicked") do
  text = get_text(text_in)
  insert_text(text_out, encode(text))
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