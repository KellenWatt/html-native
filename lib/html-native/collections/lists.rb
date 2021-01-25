require "html-native/collections"

class Array
  def to_ol(attributes: {})
    OrderedListComponent.new(self, attributes: attributes)
  end

  def to_ul(attributes: {})
    UnorderedListComponent.new(self, attributes: attributes)
  end
end
