module HTMLComponent
  class Builder
    define_method(:if) do |bool|
      if bool
        self
      else
        Builder.new
      end
    end

    define_method(:unless) do |bool|
      if bool
        Builder.new
      else
        self
      end
    end
  end

  def _if(bool, &block)
    if bool
      Builder.new(block.call)
    else
      Builder.new
    end
  end

  def _unless(bool, &block)
    unless bool
      Builder.new(block.call)
    else
      Builder.new
    end
  end
end

class String
  define_method(:if) do |bool|
    if bool
      HTMLComponent::Builder.new(self)
    else
      HTMLComponent::Builder.new
    end
  end

  define_method(:unless) do |bool|
    # BAd form, purely for symmetry
    unless bool
      HTMLComponent::Builder.new(self)
    else
      HTMLComponent::Builder.new
    end
  end
end
