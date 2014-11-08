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

def execute text
  case text
    when /^ *pwd *$/
      "Current directory: #{Dir.pwd}"
    when /^ *ls *$/
      Dir.entries(Dir.pwd).join '   '
    when /^ *cd *$/
      Dir.chdir
      "Directory changed: #{Dir.pwd}"
    when /^ *cd *[\w.]+ *$/
      text.gsub(/ *cd *([\w.]+) */) { Dir.chdir $1 }
      "Directory changed: #{Dir.pwd}"
    when /^ *mkdir *[\w]+ *$/
      text.gsub(/ *mkdir *([\w]+) */) { Dir.mkdir $1 unless Dir.exists? $1 }
      "Directory created: #{$1}"
    when /^ *rmdir *[\w]+ *$/
      text.gsub(/ *rmdir *([\w]+) */) { Dir.rmdir $1 if Dir.exists? $1 }
      "Directory removed: #{$1}"
    when /^ *set *[\w_]+ *= *[\d]+ *$/
      text.gsub(/^ *set *([\w_]+) *= *([\d]+) *$/) { $sym_table[$1] = $2 }
      "#{$1} = #{$2}"
    when /^ *set *[\w_]+ *= *["']{1}([\w_]+)['"]{1} *$/
      text.gsub(/^ *set *([\w_]+) *= *["']{1}([\w_]+)['"]{1} *$/) { $sym_table[$1] = $2 }
      "#{$1} = #{$2}"
    when /^ *echo *[\w_]+ *$/
      text.gsub(/^ *echo *([\w_])+ *$/) { $sym_table[$1] }
    when /^ *help *$/
      <<-HELP
      Available commands: pwd, ls, cd <name dir>, mkdir <name dir>, rmdir <name dir>,
      echo <var>, set <var> = <integer>, set <var> = "<string>"
      HELP
    else
      "Parse error"
  end
end

def shell text
  output = ''
  operations = text.split '|'
  operations.each { |operation| output += "#{execute(operation)}\n" }
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
  end
else
  init('EmulateShell') { |text| shell text }
end