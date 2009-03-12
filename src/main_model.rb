require 'linecounter/line_counter'

class MainModel
  include PresenterFirst::Model
  
  attr_accessor :root_path, :output_file, :extensions, :exceptions, :comments_regex
  attr_reader :errors, :file_count, :line_count
  
  def initialize
    @file_count = 0
    @line_count = 0
    @errors = []
    @root_path = Dir.pwd
    @extensions = LineCounter::EXTENSIONS.join(" ")
    @exceptions = LineCounter::EXCEPTIONS.join(" ")
    @comments_regex = LineCounter::COMMENTS_REGEX.to_s
    @output_file = "#{Dir.pwd}/files.csv"
  end
  
  def count_lines
    @file_count = 0
    @line_count = 0
    if valid?
      LineCounter::count_lines(@root_path, @output_file, 
                              @extensions.split(" "), @exceptions.split(" "), 
                              Regexp.new(@comments_regex)) do |file, lines, type|
        @file_count += 1
        @line_count += lines
        yield(file, lines, file_count, line_count)
      end
    end
    [@file_count, @line_count]
  end

  def valid?
    @errors = []
    @errors << "Root path not set and/or invalid." if @root_path.empty? or not FileTest.directory?(@root_path)
    @errors << "At least one extension must be set." if @extensions.empty? 
    @errors << "Output file must be set." if @output_file.empty? 
    @errors << "Output file can't be a directory." if FileTest.directory?(@output_file) 
    @errors.size > 0 ? false : true
  end
end