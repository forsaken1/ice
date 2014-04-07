require 'gtk2'

def get_text(tw)
  start_iter, end_iter, selected  = tw.buffer.selection_bounds

  if !selected
    start_iter, end_iter = tw.buffer.bounds
  end
  tw.buffer.get_text(start_iter, end_iter)
end

def insert_text(text_out, text)
  mark = text_out.buffer.selection_bound
  iter = text_out.buffer.get_iter_at_mark(mark)
  text_out.buffer.insert(iter, text)
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