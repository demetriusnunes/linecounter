class MainPresenter
  
  def initialize(model, view)
    @model = model; @view = view

    # Connects events with presenter and methods
    @view.connect(self) do |connect|
      connect.go_button(:mouse, :clicked) { go_clicked }
      connect.exit_button(:mouse, :clicked) { exit_clicked }
      connect.root_path_button(:mouse, :clicked) { root_path_clicked }
      connect.output_file_button(:mouse, :clicked) { output_file_clicked }
    end

    @view.bind(@model) do |binder|
      binder.simple(:root_path, :text, :root_path)
      binder.simple(:extensions, :text, :extensions)
      binder.simple(:exceptions, :text, :exceptions)
      binder.simple(:comments_regex, :text, :comments_regex)
      binder.simple(:output_file, :text, :output_file)
    end

    @view.read # read from model
    @view.show
  end
  
  def go_clicked
    @view.write # write to model
    
    @view.clear_error_messages
    @view.clear_status
    if @model.valid?
      @view.disable_buttons
      @view.enable_work_in_progress_feedback
      count_lines
      @view.enable_buttons
      @view.disable_work_in_progress_feedback
    else
      @view.show_error_messages(@model.errors.join(" "))
    end
  end

  def exit_clicked
    @view.close
  end
  
  def root_path_clicked
    if selected_path = @view.choose_root_path
      @model.root_path = selected_path
      @view.read(:root_path)
    end
  end
  
  def output_file_clicked
    if selected_file = @view.choose_output_file
      @model.output_file = selected_file
      @view.read(:output_file)
    end
  end

  private

  def count_lines
    result = @model.count_lines do |file, lines, file_count, line_count|
      @view.display_status("#{line_count} lines in #{file_count} files.\n#{lines} lines in #{File.basename(file)}")
    end
    @view.display_status("#{result[1]} lines in #{result[0]} file(s) counted.")
  rescue => ex
    @view.display_status("Error: #{ex}")
  end

end