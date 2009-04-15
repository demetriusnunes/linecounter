class MainPresenter
  
  def initialize(model, view)
    @model = model; @view = view
    @view.add_listener self, :type => :mouse, :components => %w(goButton exitButton rootPathButton outputFileButton)
    @view.update(@model, :rootPath, :extensions, :exceptions, :commentsRegex, :outputFile)
    @view.show
  end
  
  def go_button_mouse_released
    @model.update(@view, :rootPath, :extensions, :exceptions, :commentsRegex, :outputFile)
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

  def exit_button_mouse_released
    @view.close
  end
  
  def root_path_button_mouse_released
    if selected_file = @view.choose_root_path(@view[:rootPath])
      @view[:rootPath] = selected_file.getPath
    end
  end
  
  def output_file_button_mouse_released
    if selected_file = @view.choose_output_file(@view[:outputFile])
      @view[:outputFile] = selected_file.getPath
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