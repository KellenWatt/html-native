require "html-native/lists"
require "html-native/builder"

module HTMLComponent
 
  # Excluded currently because it makes checking in `Builder` ugly
  # Makes `include` and `extend` work exactly the same.
  # It's a dirty hack based on laziness, and strict use of `extend` is preferred.
  # def self.included(base)
  #   base.extend(self)
  # end

  TAG_LIST.each do |tag|
    HTMLComponent.define_method(tag) do |options = {}, &block|
      element = if block
        body = block.call.to_s
        Builder.new("<#{tag} #{attributes(tag, options)}>") + body + "</#{tag}>"
      else
        Builder.new("<#{tag} #{attributes(tag, options)}/>") 
      end
    end
  end

  def render(options={}, &block)
    Builder.new(yield(options)) if block_given?
  end

  private

  def valid_attribute?(tag, attribute)
    if LIMITED_ATTRIBUTES.key?(attribute.to_sym)
      return LIMITED_ATTRIBUTES[attribute.to_sym].include?(tag.to_sym)
    end
    return FORBIDDEN_ATTRIBUTES.include?(attribute)
  end

  def attributes(tag, options)
    options.filter{|opt, value| valid_attribute?(tag, opt)}.map do |k,v| 
      if v&.empty? 
        k.to_s
      else
        "#{k}=\"#{v}\"" # render this appropriately for numeric fields
      end
    end.join(" ")
  end
end
