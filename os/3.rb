require '../data_protection/lib/gtk.rb'
require '../data_protection/lib/lib.rb'

$sym_table = {}

class Dir
  def self.rmdir_rec path
    Dir.chdir path
    Dir.entries(Dir.pwd).each do |item|
      if Dir.exists?(item)
        Dir.rmdir_rec item
        Dir.rmdir item
      else
      end
    end
    Dir.chdir '..'
  end
end

def t_pwd
  /^ *pwd *$/
end

def t_ls
  /^ *ls *$/
end

def t_cd_null
  /^ *cd *$/
end

def t_cd
  / *cd *([\w.]+) */
end

def t_mkdir
  / *mkdir *([\w]+) */
end

def t_rmdir
  / *rmdir *([\w]+) */
end

def t_set_integer
  /^ *set *([\w_]+) *= *([\d]+) *$/
end

def t_set_string
  /^ *set *([\w_]+) *= *["]{1}([\w_]+)["]{1} *$/
end

def t_echo
  /^ *echo *([\w_]+) *$/
end

def t_interpolation
  /^ *["]{1}([\w_]*)\{([\w_]+)\}([\w_]*)["]{1} *$/
end

def t_help
  /^ *help *$/
end

def t_if
  /^ *if *([\w_]+) *do (.*) end *$/
end

def t_loop
  /^ *loop *([\w_]+) *do (.*) end *$/
end

def t_new
  /^ *new *([\w_.\/]+) *$/
end

def t_open
  /^ *open *([\w_.\/]+) *$/
end

def t_rm
  /^ *rm *([\w.\/]+) *$/
end

def t_save
  /^ *save *$/
end

def t_close
  /^ *close *$/
end

def get_help
  <<-HELP
  Available commands:
  pwd
  ls
  cd <path>
  mkdir <path>
  rmdir <path>
  --
  new <path>
  open <path>
  rm <path>
  save
  close
  --
  echo <variable>
  set <variable> = <integer>
  set <variable> = "<string>"
  "<string>$<variable><string>"
  --
  if <variable> do <block> end
  loop <variable> do <block> end
  HELP
end

def execute text, text_out = nil
  case text
    # pwd
    when t_pwd
      "Current directory: #{Dir.pwd}"
    # ls
    when t_ls
      Dir.entries(Dir.pwd).join '   '
    # cd
    when t_cd_null
      Dir.chdir
      "Directory changed: #{Dir.pwd}"
    when t_cd
      text.gsub(t_cd) { Dir.chdir $1 }
      "Directory changed: #{Dir.pwd}"
    # mkdir
    when t_mkdir
      text.gsub(t_mkdir) { Dir.mkdir $1 unless Dir.exists? $1 }
      "Directory created: #{$1}"
    # rmdir
    when t_rmdir
      text.gsub(t_rmdir) { Dir.rmdir $1 if Dir.exists? $1 }
      "Directory removed: #{$1}"
    # variables
    when t_set_integer
      text.gsub(t_set_integer) { $sym_table[$1] = $2 }
      "#{$1} = #{$2}"
    when t_set_string
      text.gsub(t_set_string) { $sym_table[$1] = $2 }
      "#{$1} = #{$2}"
    # echo
    when t_echo
      text.gsub(t_echo) { $sym_table[$1].nil? ? $1 : $sym_table[$1] }
    # interpolation
    when t_interpolation
      text.gsub(t_interpolation) { $1 + $sym_table[$2] + $3 }
    # new
    when t_new
      text.gsub(t_new) {  } # todo
    # open
    when t_open
      text.gsub(t_open) {  } # todo
    # rm
    when t_rm
      text.gsub(t_rm) {  } # todo
    # save
    when t_save
      text.gsub(t_save) {  } # todo
    # close
    when t_close
      text.gsub(t_close) {  } # todo
    # if
    when t_if
      text.gsub(t_if) {  } # todo
    # loop
    when t_loop
      text.gsub(t_loop) {  } # todo
    # help
    when t_help
      get_help
    else
      "Parse error"
  end
end

def shell text, text_out = nil
  output = ''
  operations = text.split '|'
  operations.each { |operation| output += "#{execute(operation, text_out)}\n" }
  output
end

if ARGV.first == '-t'
  test_case do
    errors = ''
    errors += test('cd', "Directory changed: /home/forsaken\n") { |text| shell text }
    errors += test('pwd', "Current directory: /home/forsaken\n") { |text| shell text }
    errors += test('mkdir test_dir', "Directory created: test_dir\n") { |text| shell text }
    errors += test('cd test_dir', "Directory changed: /home/forsaken/test_dir\n") { |text| shell text }
    errors += test('mkdir test', "Directory created: test\n") { |text| shell text }
    errors += test('ls', "..   .   test\n") { |text| shell text }
    errors += test('rmdir test', "Directory removed: test\n") { |text| shell text }
    errors += test('cd', "Directory changed: /home/forsaken\n") { |text| shell text }
    errors += test('rmdir test_dir', "Directory removed: test_dir\n") { |text| shell text }
    errors += test('set a = 42', "a = 42\n") { |text| shell text }
    errors += test('echo a', "42\n") { |text| shell text }
    errors += test('set a = "awesome"', "a = awesome\n") { |text| shell text }
    errors += test('echo a', "awesome\n") { |text| shell text }
    errors += test('"foo{a}bar"', "fooawesomebar\n") { |text| shell text }
  end
else
  init('EmulateShell') { |text| shell text }
end