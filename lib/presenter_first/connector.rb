module PresenterFirst
  
  class Connector
    
    def initialize(view, target)
      @view = view
      @target = target
    end

    def method_missing(method, *args, &block)
      if component = @view.get_field(method.to_sym)
        type, event = *args
        klass = "PresenterFirst::#{type.camelize}Handler".constantize
        handler = klass.new(@target, event, &block)
        component.send "add#{type.to_s.capitalize}Listener".to_sym, handler
      else
        super
      end
    end    
  end
end
