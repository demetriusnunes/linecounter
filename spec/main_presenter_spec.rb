require 'rubygems'
require 'spec'
require File.expand_path(File.dirname(__FILE__)) + "/../src/main_presenter"

describe MainPresenter do
  
  before(:each) do
    @view = mock("main_view")
    @model = mock("main_model")
    @view.should_receive(:add_listener).with(an_instance_of(MainPresenter), :type => :mouse, :components => %w(goButton exitButton rootPathButton outputFileButton))
    @view.should_receive(:update).with(@model, :rootPath, :extensions, :exceptions, :commentsRegex, :outputFile)
    @view.should_receive(:show)
    @presenter = MainPresenter.new(@model, @view)
  end
  
  it "should count lines and present progress if all ok" do
    @model.should_receive(:update).with(@view, :rootPath, :extensions, :exceptions, :commentsRegex, :outputFile)
    @view.should_receive(:clear_error_messages)
    @view.should_receive(:clear_status)
    @model.should_receive(:valid?).and_return(true)
    @view.should_receive(:disable_buttons)
    @view.should_receive(:enable_work_in_progress_feedback)
    @model.should_receive(:count_lines).and_yield("file", 100, 1, 100).and_return([100, 100])
    @view.should_receive(:display_status).with(an_instance_of(String)).twice
    @view.should_receive(:disable_work_in_progress_feedback)
    @view.should_receive(:enable_buttons)
    @presenter.go_button_mouse_released
  end
  
  it "should present an error message when invalid/missing fields" do
    @model.should_receive(:update).with(@view, :rootPath, :extensions, :exceptions, :commentsRegex, :outputFile)
    @view.should_receive(:clear_error_messages)
    @view.should_receive(:clear_status)
    @model.should_receive(:valid?).and_return(false)
    @model.should_receive(:errors).and_return(["err1"])
    @view.should_receive(:show_error_messages).with("err1")
    @presenter.go_button_mouse_released
  end
  
  it "should present an error status when invalid output file or any other error ocurred" do
    @model.should_receive(:update).with(@view, :rootPath, :extensions, :exceptions, :commentsRegex, :outputFile)
    @view.should_receive(:clear_error_messages)
    @view.should_receive(:clear_status)
    @model.should_receive(:valid?).and_return(true)
    @view.should_receive(:disable_buttons)
    @view.should_receive(:enable_work_in_progress_feedback)
    @model.should_receive(:count_lines).and_raise("Error Occurred")
    @view.should_receive(:display_status).with(an_instance_of(String)).once
    @view.should_receive(:disable_work_in_progress_feedback)
    @view.should_receive(:enable_buttons)
    @presenter.go_button_mouse_released
  end
  
  it "should present a directory selection dialog when Choose... is clicked for the root path field" do
    directory = "/tmp/"
    selected_file = "/tmp/"
    selected_file.stub!(:getPath).and_return(directory)
    @view.should_receive(:[]).with(:rootPath).and_return(directory)
    @view.should_receive(:choose_root_path).with(directory).and_return(selected_file)
    @view.should_receive(:[]=).with(:rootPath, directory)
    @presenter.root_path_button_mouse_released
  end

  it "should present a file/directory selection dialog when Choose... is clicked for the output file field" do
    file = "/tmp/file.csv"
    selected_file = "/tmp/file.csv"
    selected_file.stub!(:getPath).and_return(file)
    @view.should_receive(:[]).with(:outputFile).and_return(file)
    @view.should_receive(:choose_output_file).with(file).and_return(selected_file)
    @view.should_receive(:[]=).with(:outputFile, file)
    @presenter.output_file_button_mouse_released
  end
    
  it "should exit the app when exit clicked" do
    @view.should_receive(:close).once
    @presenter.exit_button_mouse_released
  end
end