require 'rubygems'
require 'spec'
require 'spec/autorun'
require File.expand_path(File.dirname(__FILE__)) + "/../src/main_presenter"

describe MainPresenter do
  
  before(:each) do
    @view = mock("main_view")
    @model = mock("main_model")
    @view.should_receive(:connect).with(an_instance_of(MainPresenter))
    @view.should_receive(:bind).with(@model)
    @view.should_receive(:read)
    @view.should_receive(:show)
    @presenter = MainPresenter.new(@model, @view)
  end

  def reset_view
    @view.should_receive(:write)
    @view.should_receive(:clear_error_messages)
    @view.should_receive(:clear_status)
  end
  
  it "should count lines and present progress if all ok" do
    reset_view
    @model.should_receive(:valid?).and_return(true)
    @view.should_receive(:disable_buttons)
    @view.should_receive(:enable_work_in_progress_feedback)
    @model.should_receive(:count_lines).and_yield("file", 100, 1, 100).and_return([100, 100])
    @view.should_receive(:display_status).with(an_instance_of(String)).twice
    @view.should_receive(:disable_work_in_progress_feedback)
    @view.should_receive(:enable_buttons)
    @presenter.go_clicked
  end
  
  it "should present an error message when invalid/missing fields" do
    reset_view
    @model.should_receive(:valid?).and_return(false)
    @model.should_receive(:errors).and_return(["err1"])
    @view.should_receive(:show_error_messages).with("err1")
    @presenter.go_clicked
  end
  
  it "should present an error status when invalid output file or any other error ocurred" do
    reset_view
    @model.should_receive(:valid?).and_return(true)
    @view.should_receive(:disable_buttons)
    @view.should_receive(:enable_work_in_progress_feedback)
    @model.should_receive(:count_lines).and_raise("Error Occurred")
    @view.should_receive(:display_status).with(an_instance_of(String)).once
    @view.should_receive(:disable_work_in_progress_feedback)
    @view.should_receive(:enable_buttons)
    @presenter.go_clicked
  end
  
  it "should present a directory selection dialog when Choose... is clicked for the root path field" do
    path = "/tmp/"
    @view.should_receive(:choose_root_path).and_return(path)
    @model.should_receive(:root_path=).with(path)
    @view.should_receive(:read).with(:root_path)
    @presenter.root_path_clicked
  end

  it "should present a file/directory selection dialog when Choose... is clicked for the output file field" do
    file = "/tmp/file.csv"
    @view.should_receive(:choose_output_file).and_return(file)
    @model.should_receive(:output_file=).with(file)
    @view.should_receive(:read).with(:output_file)
    @presenter.output_file_clicked
  end
    
  it "should exit the app when exit clicked" do
    @view.should_receive(:close).once

    @presenter.exit_clicked
  end
end