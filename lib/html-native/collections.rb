require "html-native"
require "html-native/builder"
class OrderedListComponent
  include HTMLComponent

  def initialize(data, attributes: {list: {}, item: {}})
    @list_data = data
    @list_attributes = attributes[:list] || {}
    @item_attributes = attributes[:item] || {}
  end

  def render(&block)
    ol(@list_attributes) do
      @list_data.inject(Builder.new) do |acc, l|
        acc + li(@item_attributes) do
          block_given? ? block.call(l) : l.to_s
        end
      end
    end
  end
end

class UnorderedListComponent
  include HTMLComponent

  def initialize(data, attributes: {list: {}, item: {}})
    @list_data = data
    @list_attributes = attributes[:list] || {}
    @item_attributes = attributes[:item] || {}
  end

  def render(&block)
    ul(@list_attributes) do
      @list_data.inject(Builder.new) do |acc, l|
        acc + li(@item_attributes) do
          block_given? ? block.call(l) : l.to_s
        end
      end
    end
  end
end

class ListComponent
  def initialize(data, attributes: {list: {}, item: {}}, ordered: false)
    @list = ordered ? OrderedListComponent.new(data, attributes) : 
                      UnorderedListComponent.new(data, attributes)
  end

  def render(&block)
    @list.render(&block)
  end
end

class TableRowComponent
  include HTMLComponent
  
  def initialize(data, attributes: {row: {}, cell: {}})
    @data = data
    @row_attributes = attributes[:row] || {}
    @cell_attributes = attributes[:cell] || {}
  end

  def render(&block)
    tr(@row_attributes) do
      @data.inject(Builder.new) do |acc, c|
        acc + td(@cell_attributes) {block_given? ? yield(c) : c}
      end
    end
  end
end

# This needs some reworking, since it's not intuitive
class TableComponent
  include HTMLComponent
 
  def initialize(header, rows, attributes: {table: {}, header: {}, header_cell: {}, row: {}, cell: {}})
    @header = header
    @rows = rows
    @table_attributes = attributes[:table] || {}
    @header_attributes = attributes[:header] || {}
    @header_cell_attributes = attributes[:header_cell] || {}
    @row_attributes = attributes[:row] || {}
    @cell_attributes = attributes[:cell] || {}
  end

  # header options:
  # array - use as header
  # symbol - if :from_data, then use first row, if :none, set @header to nil
  def self.from_array(data, attributes: {table: {}, header: {}, header_cell: {}, row: {}, cell: {}}, header: :none)
    head = rows = nil
    if header == :from_data
      head = data[0]
      rows = data[1..]
    else
      head = header.kind_of?(Array) ? header : nil
      rows = data
    end
    new(head, rows, attributes: attributes)
  end

  def self.from_hash(data, attributes: {table: {}, header: {}, header_cell: {}, row: {}, cell: {}}, vertical: true)
    if vertical
      rowcount = data.values.map(&:length).max
      rows = [] * rowcount
      data.each do |k,col|
        rowcount.times do |i|
          rows[i] << (i < col.size ? col[i] : nil)
        end
      end
      new(data.keys, rows, attributes: attributes)
    else
      rows = data.map do |k, v|
        [k] + v
      end
      new(nil, rows, attributes: attributes)
    end
  end

  def render(&block)
    table(@table_attributes) do
      if @header
        tr(@row_attributes.merge(@header_attributes)) do
          @header.inject(Builder.new) do |acc, h|
            acc + th(@cell_attributes.merge(@header_cell_attributes)) {h}
          end
        end
      else
        Builder.new
      end +
      @rows.inject(Builder.new) do |acc, row|
        acc + TableRowComponent.new(row, attributes: {row: @row_attributes, cell: @cell_attributes}).render(&block)
      end
    end
  end
end
