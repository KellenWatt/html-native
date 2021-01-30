require "html-native/constants"
require "html-native/builder"

module HTMLComponent
 
  # Generates generation methods for each HTML5-valid tag. These methods have the 
  # name of the tag. Note that this interferes with the builtin `p` method.
  TAG_LIST.each do |tag|
    HTMLComponent.define_method(tag) do |attrs = {}, &block|
      attrs ||= {}
      if block
        body = block.call
        Builder.new("<#{tag}#{attributes_list(tag, attrs)}>") + body + "</#{tag}>"
      else
        Builder.new("<#{tag}#{attributes_list(tag, attrs)}/>") 
      end
    end
  end

  # Creates a module that encompasses the given block in an HTMLComponent
  # context. This gives access to methods in the block as though the block was 
  # declared as the `render` function in a module extending HTMLComponent 
  # (pretty much because it is).
  def self.singleton(&block)
    Module.new do
      extend HTMLComponent
      define_singleton_method :render, &block
    end
  end

  # Checks if the attribute is valid for a given tag.
  #
  # For example, `class` and `hidden` are valid for everything, but `autoplay` 
  # is valid for only `video` and `audio` tags, and invalid for all other tags.
  def valid_attribute?(tag, attribute)
    if LIMITED_ATTRIBUTES.key?(attribute.to_sym)
      return LIMITED_ATTRIBUTES[attribute.to_sym].include?(tag.to_sym)
    end
    return !FORBIDDEN_ATTRIBUTES.include?(attribute)
  end
  
  private

  # Given a tag and a set of attributes as a hash, format the attributes to 
  # HTML-valid form. If an attribute doesn't have a value or the value is 
  # empty, it's treated as a boolean attribute and formatted as such.
  def attributes_list(tag, attrs)
    formatted = attrs.filter{|opt, value| valid_attribute?(tag, opt)}.map do |k,v| 
      if v&.to_s.empty?
        k.to_s
      else
        "#{k}=\"#{v}\"" # render this appropriately for numeric fields (might already)
      end
    end.join(" ")
    formatted.prepend(" ") unless formatted.empty?
  end
end
