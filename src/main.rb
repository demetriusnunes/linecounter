$: << "lib"
$: << "src"

require 'java'
require 'presenter_first/presenter_first'

require 'main_model'
require 'main_view'
require 'main_presenter'

MainPresenter.new(MainModel.new, MainView.new)