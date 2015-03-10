require '../data_protection/lib/gtk.rb'
require '../data_protection/lib/lib.rb'

$sym_table = {}
$filename = nil

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
  / *cd *([\w.~\/]+) */
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

def t_execute
  /^ *execute *([\w_.\/]+) *$/
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

def t_operation
  /^ *([\w_]+) *(\+|\-|\*|\\) *([\w_]+) *$/
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
  execute <path>
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
  --
  <variable> + <variable>
  <variable> - <variable>
  <variable> * <variable>
  <variable> / <variable>
  HELP
end

def operation a, b, oper
  case oper
    when '+'
      a + b
    when '-'
      a - b
    when '*'
      a * b
    when '/'
      a / b
    else
      "Incorrect operation"
  end
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
    # execute
    when t_execute
      text.gsub(t_execute) do
        if File.exists? $1
          shell File.open($1).read, text_out
        else
          "File not found"
        end
      end
    # new
    when t_new
      text.gsub(t_new) do
        if File.exists? $1
          "File exists"
        else
          File.open($1, "w+") do |f|
            f.write ''
            f.close
          end
          "File created"
        end
      end
    # open
    when t_open
      text.gsub(t_open) do
        if File.exists? $1
          $filename = $1
          File.open($filename).read
        else
          "File not found"
        end
      end
    # rm
    when t_rm
      text.gsub(t_rm) do
        if File.exists? $1
          File.unlink $1
          "File deleted"
        else
          "File not found"
        end
      end
    # save
    when t_save
      unless $filename.nil?
        File.open($filename, "w+") { |f| f.write(get_text(text_out)) if text_out }
        "File saved"
      else
        "File not opened"
      end
    # close
    when t_close
      unless $filename.nil?
        $filename = nil
        "File closed"
      else
        "File not opened"
      end
    # if
    when t_if
      text.gsub(t_if) { if $sym_table[$1].to_i != 0 then shell($2, text_out) end }
    # loop
    when t_loop
      result = ''
      text.gsub(t_loop) { $sym_table[$1].to_i.times { result += shell($2, text_out) } }
      result
    # operation
    when t_operation
      text.gsub(t_operation) { operation($sym_table[$1].to_i, $sym_table[$3].to_i, $2)  }
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
    errors += test('set a = 3|loop a do echo a end', "a = 3\n3\n3\n3\n\n") { |text| shell text }
    errors += test('set a = 1|if a do echo a end', "a = 1\n1\n\n") { |text| shell text }
    errors += test('set a = 0|if a do echo a end', "a = 0\n\n") { |text| shell text }
    errors += test('set a = 9|set b = 3', "a = 9\nb = 3\n") { |text| shell text }
    errors += test('a + b', "12\n") { |text| shell text }
    errors += test('a - b', "6\n") { |text| shell text }
    errors += test('a * b', "27\n") { |text| shell text }
    #errors += test('a / b', "3\n") { |text| shell text }
  end
else
  init('EmulateShell') { |text, out| shell text, out }
end