require 'rubygems'
require 'spec'
require File.expand_path(File.dirname(__FILE__)) + "/../../src/main"

Before do
  @view = MainView.new
  @model = MainModel.new
  @presenter = MainPresenter.new(@model, @view)
end

After do
  @presenter.exit_button_mouse_released
end