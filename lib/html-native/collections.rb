module HTMLComponent
  # lists
  def ordered_list(list, attributes: {}, item_attributes: {}, &block)
    ol(attributes) {
      list.inject(Builder.new) do |acc, l|
        acc + li(item_attributes) {
                block_given? ? block.call(l) : l.to_s
              }
      end
    }
  end

  def ordered_list(list, attributes: {}, item_attributes: {}, &block)
    ul(attributes) {
      list.inject(Builder.new) do |acc, l|
        acc + li(item_attributes) {
                block_given? ? block.call(l) : l.to_s
              }
      end
    }
  end

  def list(list, attributes: {}, item_attributes: {}, ordered: false, &block)
    self.__send__(ordered ? :ordered_list : :unordered_list, attributes, item_attributes, &block)
  end

  # tables

end
