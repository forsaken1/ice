require '../data_protection/lib/gtk.rb'

def execute text
  case text
    when /^ *pwd *$/
      Dir.pwd
    when /^ *ls *$/
      Dir.entries(Dir.pwd).join '   '
    when /^ *cd *$/
      Dir.chdir
      "Directory changed: #{Dir.pwd}"
    when /^ *cd *[\w]* *$/
      text.gsub(/ *cd *([\w]*) */) { Dir.chdir $1 }
      "Directory changed: #{Dir.pwd}"
    when /^ *mkdir *[\w]+$/
      text.gsub(/ *mkdir *([\w]+) */) { Dir.mkdir $1 }
      "Directory created: #{Dir.pwd}"
    when /^ *help *$/
      "Available commands: pwd, ls, cd <name dir>, mkdir <name dir>"
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

init('EmulateShell') { |text| shell text }