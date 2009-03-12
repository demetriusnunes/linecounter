include_class "javax.swing.JFileChooser"
include_class "java.awt.Cursor"  

class MainView < PresenterFirst::View
  set_screen "MainScreen"

  def enable_buttons
    goButton.enabled = true
    exitButton.enabled = true
  end
  
  def disable_buttons
    goButton.enabled = false
    exitButton.enabled = false
  end
  
  def clear_error_messages
    validation.visible = false
    validation.text = ""
  end
  
  def show_error_messages(messages)
    validation.visible = true
    validation.text = messages
  end

  def clear_status
    status.visible = false
    status.text = ""
  end
  
  def display_status(message)
    status.visible = true
    status.text = message
  end

  def choose_root_path(initial_path)
    fc = JFileChooser.new(initial_path)
    fc.setFileSelectionMode(JFileChooser::DIRECTORIES_ONLY)
    fc.showOpenDialog(@screen)
    fc.getSelectedFile
  end

  def choose_output_file(initial_path)
    fc = JFileChooser.new(initial_path)
    fc.setFileSelectionMode(JFileChooser::FILES_AND_DIRECTORIES)
    fc.showOpenDialog(@screen)
    fc.getSelectedFile
  end

  def enable_work_in_progress_feedback
    @screen.setCursor(Cursor.getPredefinedCursor(Cursor::WAIT_CURSOR))
    progressBar.setIndeterminate(true)
  end
  
  def disable_work_in_progress_feedback
    @screen.setCursor(Cursor.getPredefinedCursor(Cursor::DEFAULT_CURSOR))
    progressBar.setIndeterminate(false)
  end
  
  
  def close
    dispose
  end
  
end