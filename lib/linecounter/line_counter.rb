require 'find'

module LineCounter
  EXTENSIONS = %w(java js sql xml properties html py css conf page jwc bat form script cmd rb xslt template xsl htm iss pas xsd)
  EXCEPTIONS = %w(log build bin javadoc) 
  COMMENTS_REGEX = /^[\/\*\*|\/\/|\*|\*\/|\-\-|\#]/
  
  def LineCounter::lines_in_file(path, regex_comments = COMMENTS_REGEX)
    lines = []
    count = 0
    open(path) { |file| lines = file.readlines }
    for line in lines
      line = line.strip
      count += 1 unless line.size < 2 or line =~ regex_comments
    end
    count
  end

  def LineCounter::count_lines(root_path, output_file = "line_count.csv", extensions = EXTENSIONS, exceptions = EXCEPTIONS, regex_comments = COMMENTS_REGEX)
    files = []
    Find.find(root_path) do |path|
      if FileTest.directory?(path)
        if File.basename(path)[0] == ?. || exceptions.include?(File.basename(path))
          Find.prune
        else
          next
        end
      else
        extension = File.extname(path)[1..-1]
        if extensions.include?(extension)
          file = path.gsub(Dir.pwd, "")
          lines = lines_in_file(path, regex_comments)
          files << [ file, lines, extension ].join(",")
          yield(file, lines, extension)
        end
      end
    end

    open(output_file, "w+") { |file| file.puts("File,Lines,Type"); file.puts(files.join("\n")) }    
  end
end