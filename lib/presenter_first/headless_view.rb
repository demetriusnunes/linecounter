module PresenterFirst
  module HeadlessView

    def show
      @visible = true
    end
    
    def hide
      @visible = false
    end

    def visible?
      @visible
    end
    
    def visible=(visibility)
      @visible = visibility
    end    

  end
end