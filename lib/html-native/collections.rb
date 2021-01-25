require "html-native"
class OrderedListComponent
  include HTMLComponent

  def initialize(data)
    @list_data = data
  end

  def render(attributes: {}, item_attributes: {}, &block)
    ol(attributes) do
      @list_data.inject(Builder.new) do |acc, l|
        acc + li(item_attributes) do
          block_given? ? block.call(l) : l.to_s
        end
      end
    end
  end
end

class UnorderedListComponent
  include HTMLComponent

  def initialize(data)
    @list_data = data
  end

  def render(attributes: {}, item_attributes: {}, &block)
    ul(attributes) do
      @list_data.inject(Builder.new) do |acc, l|
        acc + li(item_attributes) do
          block_given? ? block.call(l) : l.to_s
        end
      end
    end
  end
end

class ListComponent
  def initialize(data, ordered: false)
    @list = ordered ? OrderedListComponent.new(data) : UnorderedListComponent.new(data)
  end

  def render(attributes: {}, item_attributes: {}, &block)
    @list.render(attributes, item_attributes, &block)
  end
end

module HTMLComponent
  # tables

  # This could be more complete, but needs polishing and to consider the cases
  # Doesn't work for now. Here for reference
  def self.table_from(data, col_names: [], attributes: {}, header_attrs: {}, 
                 row_attrs: {}, cell_attrs: {}, &block)
    table(attributes) do
      unless col_names.empty?
        tr(row_attrs) do
          col_names.inject(Builder.new) do |acc, c|
            acc + th(cell_attrs.merge(header_attrs)) {c.to_s}
          end
        end 
      end +
      data.inject(Builder.new) do |acc, row|
        acc + tr(row_attrs) do
          if block_given? 
            yield row
          else
            row.inject(Builder.new) do |acc, cell|
              acc + td(cell_attrs) {cell.to_s} 
            end
          end
        end
      end
    end
  end
end
