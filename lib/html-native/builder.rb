require "html-native"
module HTMLComponent
  # Represents a String being constructed, and can be more or less treated 
  # as a String. Builder creates a String from whatever is put into it, but 
  # it delays construction until it's absolutely necessary, then it caches the
  # result.
  class Builder
    # Build a new string builder instance, immediately constructing and caching 
    # the initial value.
    def initialize(strings = [])
      @strings = []
      @cache = case strings.class 
      when Array
        strings.join
      when Enumerable
        strings.to_a.join
      else
        strings.to_s
      end
      @cached = true
    end

    # Appends a value to the Builder instance. If it is another builder, it is 
    # added, but not converted to a String yet. If it is an HTMLComponent, it is 
    # rendered. If it is anything else, it is converted to a String. This 
    # invalidates the cache.
    def +(string)
      if string.kind_of? Builder 
        @strings << string
      elsif string.kind_of? HTMLComponent
        @strings << string.render
      else
        @strings << string.to_s
      end
      @cached = false
      self
    end

    alias_method :<<, :+

    # Same as +, but allows multiple values to be appended. 
    def concat(*strings)
      strings.each do |s|
        self + s
      end
      self
    end

    # Converts the Builder to a String. If the cache is valid, it is returned. 
    # Otherwise, the new result is created, cached, and returned.
    def to_s
      unless @cached
        @cache << @strings.join
        @strings.clear
        @cached = true
      end
      @cache
    end

    alias to_str to_s

    # If the method does not exist on Builder, it is sent to String, by way 
    # of the rendered Builder result. Modify-in-place methods will affect the 
    # underlying String.
    def method_missing(method, *args, &block)
      to_s.send(method, *args, &block)
    end
    
    # If String responds to the method, then Builder also responds to it.
    def respond_to_missing?(method)
      "".respond_to?(method)
    end
  end
end

class String
  def component
    HTMLComponent::Builder.new(self)
  end
end
