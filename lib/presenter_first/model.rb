module PresenterFirst
  module Model
    def update(view, *fields)
      for field in fields
        self.send("#{field.to_s.underscore}=", view[field])
      end
    end
  end
end