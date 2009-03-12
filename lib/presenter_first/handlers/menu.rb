include_class 'javax.swing.event.MenuListener'

module PresenterFirst
  class MenuHandler < BaseHandler
    include MenuListener
    set_events :menu, %w(Canceled Deselected Selected)
  end
end