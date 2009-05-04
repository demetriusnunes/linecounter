module PresenterFirst
  
  class Binder

    def initialize(view)
      @view = view
      @bindings = []
    end

    def execute
      @bindings.each do |component, action|
        action.call(component)
      end
    end
    
    def method_missing(method, *args, &block)
      if component = @view.get_field(method.to_sym)
        @bindings << [ component, block ]
      else
        super
      end
    end
    
  end

end