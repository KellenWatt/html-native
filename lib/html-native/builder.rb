require "html-native"
module HTMLComponent
  class Builder
    def initialize(strings = [])
      if strings.kind_of? String 
        @strings = [strings]
      else
        @strings = strings.dup
      end
    end

    def +(string)
      if string.kind_of? Builder 
        @strings << string
      elsif string.kind_of? HTMLComponent
        @strings << string.render
      else
        @strings << string.to_s
      end
      self
    end

    def to_s
      @strings.join
    end

    alias to_str to_s
  end
end

class String
  def component
    HTMLComponent::Builder.new(self)
  end
end
