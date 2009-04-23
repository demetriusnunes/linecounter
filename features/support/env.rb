require 'rubygems'
require 'spec'
require File.expand_path(File.dirname(__FILE__)) + "/../../src/main"

class Java::JavaxSwing::JFileChooser
  def showOpenDialog(*args) end

  def getSelectedFile
    selected_file = "some_file.dat"
    def selected_file.getPath; self end
    selected_file
  end
end

Before do
  @view = MainView.headless.new
  @model = MainModel.new
  @presenter = MainPresenter.new(@model, @view)
end

After do
  @presenter.exit_button_mouse_released
end

at_exit do
  java.lang.System.exit(0)
end