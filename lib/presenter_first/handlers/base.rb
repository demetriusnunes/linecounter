include_class "foxtrot.Worker"

module PresenterFirst
  class BaseHandler

    def self.set_events(type, events)
      events.each do |event|
        define_method("#{type}#{event}") do |args|
          if event.to_s.downcase == @event.to_s.downcase
            unless @handler.nil?
              runner = ::PresenterFirst::Runner.new
              runner.proc = proc { @handler.arity == 0 ? @handler.call : @handler.call(args) }
              Worker.post(runner)
            end
          end
        end
      end
    end
      
    def initialize(target, event, &handler)
      @target = target
      @event = event
      @handler = handler
    end
    
  end
end