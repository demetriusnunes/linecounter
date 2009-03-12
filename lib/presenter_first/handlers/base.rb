module PresenterFirst
  class BaseHandler

    def self.set_events(type, events)
      events.each do |event|
        define_method("#{type}#{event}") do |args|
          @target.handle_event("#{type}_#{event.downcase}", args)
        end
      end
    end
      
    def initialize(target)
      @target = target
    end
    
  end
end