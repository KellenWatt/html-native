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
end

class String
  define_method(:if) do |bool|
    if bool
      Builder.new(self)
    else
      Builder.new
    end
  end

  define_method(:unless) do |bool|
    # BAd form, purely for symmetry
    unless bool
      Builder.new(self)
    else
      Builder.new
    end
  end
end
