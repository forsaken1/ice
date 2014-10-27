require '../data_protection/lib/gtk.rb'
require '../data_protection/lib/lib.rb'

$sym_table = {}

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
      text.gsub(/ *cd *([\w.]*) */) { Dir.chdir $1 }
      "Directory changed: #{Dir.pwd}"
    when /^ *mkdir *[\w]+ *$/
      text.gsub(/ *mkdir *([\w]+) */) { Dir.mkdir $1 }
      "Directory created: #{$1}"
    when /^ *rmdir *[\w]+ *$/
      text.gsub(/ *rmdir *([\w]+) */) { Dir.rmdir $1 }
      "Directory removed: #{$1}"
    when /^ *help *$/
      "Available commands: pwd, ls, cd <name dir>, mkdir <name dir>, rmdir <name dir>,\n echo <var>, set <var> = <value>"
    when /^ *set *[\w_]+ *= *[\d]+ *$/
      text.gsub(/^ *set *([\w_])+ *= *([\d])+ *$/) { $sym_table[$1] = $2 }
      "#{$1} = #{$2}"
    when /^ *set *[\w_]+ *= *["']{1}([\w_]+)['"]{1} *$/
      text.gsub(/^ *set *([\w_]+) *= *["']{1}([\w_]+)['"]{1} *$/) { $sym_table[$1] = $2 }
      "#{$1} = #{$2}"
    when /^ *echo *[\w_]+ *$/
      text.gsub(/^ *echo *([\w_])+ *$/) { $sym_table[$1] }
    else
      "Parse error"
  end
end

def shell text
  output = ''
  operations = text.split '|'
  operations.each { |operation| output += execute(operation) + "\n" }
  output
end

test_case do
  errors = ''
  errors += test('cd', 'Directory changed: /home/forsaken') { |text| shell text }
end

init('EmulateShell') { |text| shell text }