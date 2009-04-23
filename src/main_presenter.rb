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

    @view.bind do |read, write|
      read.root_path { |control| control.text = @model.root_path }
      write.root_path { |control| @model.root_path = control.text }
      
      read.extensions { |control| control.text = @model.extensions }
      write.extensions { |control| @model.extensions = control.text }

      read.exceptions { |control| control.text = @model.exceptions }
      write.exceptions { |control| @model.exceptions = control.text }

      read.comments_regex { |control| control.text = @model.comments_regex }
      write.comments_regex { |control| @model.comments_regex = control.text }

      read.output_file  { |control| control.text = @model.output_file }
      write.output_file  { |control| @model.output_file = control.text }
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
    if selected_file = @view.choose_root_path(@view[:rootPath])
      @view[:rootPath] = selected_file.getPath
    end
  end
  
  def output_file_clicked
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