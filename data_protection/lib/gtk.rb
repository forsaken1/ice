require 'gtk2'

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
  history = []
  current_history_item = 0

  window = Gtk::Window.new
  window.set_title(title)
  window.border_width = 10
  window.resizable = true
  window.set_size_request(600, 300)

  text_in = Gtk::TextView.new
  text_out = Gtk::TextView.new

  main_process = Proc.new do
    text = get_text(text_in)
    history << text
    current_history_item = history.count - 1
    insert_text(text_out, yield(text))
    insert_text(text_in, '')
  end

  text_in.signal_connect('key-press-event') do |o, event|
    case event.keyval
      when Gdk::Keyval::GDK_KEY_Up
        insert_text(text_in, history[current_history_item]) unless history[current_history_item].nil?
        current_history_item -= 1 if current_history_item > 0
      when Gdk::Keyval::GDK_KEY_Down
        current_history_item += 1 if current_history_item < history.count - 1
        insert_text(text_in, history[current_history_item]) unless history[current_history_item].nil?
      when Gdk::Keyval::GDK_KEY_Return
        main_process.call
    end
  end

  button = Gtk::Button.new("Run")
  button.signal_connect("clicked") do
    main_process.call
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