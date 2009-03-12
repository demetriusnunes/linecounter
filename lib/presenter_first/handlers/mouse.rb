include_class 'java.awt.event.MouseListener'

module PresenterFirst
  class MouseHandler < BaseHandler
    include MouseListener
    set_events :mouse, %w(Clicked Entered Exited Pressed Released)
  end
end