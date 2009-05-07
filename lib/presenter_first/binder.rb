module PresenterFirst
  
  class Binder
    attr_reader :view, :model, :bindings
    
    def initialize(view, model)
      @view, @model = view, model
      @bindings = []
    end

    def simple(field, property, attribute)
      read(field) do |control, model|
        view[field].send("#{property}=", model.send(attribute))
      end
      write(field) do |control, model|
        model.send("#{attribute}=", view[field].send(property))
      end
    end

    def read(field, &block)
      @bindings << ReadBinding.new(self, field, &block)
    end

    def write(field, &block)
      @bindings << WriteBinding.new(self, field, &block)
    end
    
    def execute(read_or_write, *fields)
      @bindings.each do |binding|
        if fields.empty? || fields.include?(binding.field)
          binding.execute(read_or_write)
        end
      end
    end
    
  end

  class Binding
    attr_reader :field
    
    def initialize(binder, field, &block)
      @binder = binder
      @field = field
      @block = block
    end

    def execute(read_or_write)
      @block.call(@binder.view[@field], @binder.model)
    end
  end

  class ReadBinding < Binding
    def execute(read_or_write)
      return unless read_or_write == :read
      super
    end
  end
  
  class WriteBinding < Binding
    def execute(read_or_write)
      return unless read_or_write == :write
      super
    end
  end
  
end