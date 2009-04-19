include_class javax.swing.JComponent
include_class javax.swing.KeyStroke

include_class "foxtrot.Worker"
include_class "foxtrot.Job"

require "presenter_first/inflector"

module PresenterFirst
  class Runner < Job
    attr_accessor :proc
    def run
      @proc.call
    end
  end
  
  class View
    # Declares what class to instantiate when creating the view.  Any listeners
    # set on the controller are added to this class as well as the setting of the
    # close action that is defined in the controller.
    def self.set_screen(java_class)
      include_class java_class
      class_name = /.*?\.?(\w+)$/.match(java_class)[1]
      self.send(:class_variable_set, :@@java_class, const_get(class_name))
    end

    public
    def initialize
      @field_references = {}
      @@is_a_java_class = self.class.class_variables.member?("@@java_class") && self.class.send(:class_variable_get, :@@java_class).ancestors.member?(Java::JavaLang::Object)
      if @@is_a_java_class
        @screen = @main_view_component = self.class.send(:class_variable_get, :@@java_class).new
        fields = self.class.send(:class_variable_get, :@@java_class).java_class.declared_fields
        fields.each do |declared_field|
          field = get_field(declared_field.name)
          field.name = declared_field.name if field.class.kind_of?(java.awt.Component.class)
        end
      end
    end
    
    def set_fields(fields = {})
      for field, value in fields
        get_field(field).text = value.to_s
      end
    end

    def fields(*fields_sym)
      fields_sym.inject([]) { |values, field|
        values << get_field(field).text
      }
    end

    def []=(field, value)
      get_field(field).text = value
    end
    
    def [](field)
      get_field(field).text
    end
    
    def update(model, *fields)
      for field in fields
        get_field(field).text = model.send(field.to_s.underscore)
      end
    end
    
    def add_listener(listener, details)
      klass = "PresenterFirst::#{details[:type].camelize}Handler".constantize
      handler = klass.new(listener)
      listener.instance_eval do 
        def handle_event(event_name, event)
          method = "#{event.source.name.underscore}_#{event_name}".to_sym
          begin; proc = method(method); rescue; end
          unless proc.nil?
            runner = ::PresenterFirst::Runner.new
            runner.proc = proc { proc.arity == 0 ? proc.call : proc.call(event) }
            Worker.post(runner)
          end
        end
      end
      add_handler(details[:type], handler, details[:components])
    end
    
    def define_handler(action, &block)
      define_method action, block
    end

    def visible?
      return @main_view_component.visible
    end
    
    def visible=(visibility)
      @main_view_component.visible = visibility
    end
    
    def show
      @main_view_component.visible = true
    end
    
    def hide
      @main_view_component.visible = false
    end

    def dispose
      @main_view_component.dispose
    end
    
    def add_handler(type, handler, components)
      warn "Adding #{type.inspect}"
      components = ["global"] if components.nil?
      components.each do |component|
        if "global" == component
          get_all_components.each do |component|
            component.send("add#{type.to_s.capitalize}Listener".to_sym, handler)
          end
        else
          get_field(component).send("add#{type.to_s.capitalize}Listener", handler)
        end
      end
    end
    
    # Attempts to find a member variable in the underlying @main_view_component
    # object if one is set, otherwise falls back to default method_missing implementation.
    def method_missing(method, *args, &block)
      begin
        return get_field(method)
      rescue NameError
        super
      end
    end
    
    private
    # Uses reflection to pull a private field out of the Java objects.  In cases where
    # no Java object is being used, the view object itself is referenced.
    def get_field(field_name)
      field_name = field_name.to_sym
      field = @field_references[field_name]
      if field.nil?
        unless @@is_a_java_class
          field = method(field_name).call
        else
          field_object = nil
          [field_name.to_s, field_name.camelize, field_name.camelize(false)].uniq.each do |name|
            begin
              field_object = self.class.send(:class_variable_get, :@@java_class).java_class.declared_field(name)
            rescue NameError, NoMethodError => e
            end
            break unless field_object.nil?
          end
          raise UndefinedControlError, "There is no control named #{field_name} on view #{@main_view_component.class}" if field_object.nil?
          
          field_object.accessible = true
          field = Java.java_to_ruby(field_object.value(Java.ruby_to_java(@main_view_component)))
        end
        @field_references[field_name] = field
      end
      field
    end
    
    def get_all_components(list = [], components = @main_view_component.components)
      components.each do |component|
        list << component
        get_all_components(list, component.components) if component.respond_to? :components
      end
      list
    end
    
  end
end

class UndefinedControlError < Exception; end
