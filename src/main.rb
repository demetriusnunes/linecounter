$: << "lib"
$: << "src"

require 'java'
require "MainScreen.jar"
require "swing-layout-1.0.2.jar"

require 'presenter_first/presenter_first'

require 'main_model'
require 'main_view'
require 'main_presenter'

if $0 == __FILE__
  MainPresenter.new(MainModel.new, MainView.new)
end