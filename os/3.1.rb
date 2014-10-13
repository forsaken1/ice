require '../data_protection/lib/gtk.rb'

def shell text
  case text
  	when /^ *pwd *$/
  	  Dir.pwd
  	when /^ *ls *$/
  	  Dir.entries(Dir.pwd).join '   '
  	when /^ *cd *$/
  	  Dir.chdir
  	  "Directory changed: #{Dir.pwd}"
  	when /^ *cd *[\w]*$/
  	  text.gsub(/ *cd *([\w]*)/) { Dir.chdir $1 }
      "Directory changed: #{Dir.pwd}"
    when /^ *mkdir *[\w]+$/
      text.gsub(/ *mkdir *([\w]+)/) { Dir.mkdir $1 }
      "Directory created: #{Dir.pwd}"
    else
      "Parse error"
  end
end

init('EmulateShell') { |text| shell text }