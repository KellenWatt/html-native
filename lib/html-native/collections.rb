require "html-native"
require "html-native/builder"
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

class TableRowComponent
  include HTMLComponent
  
  def initialize(data)
    @data = data
  end

  def render(attributes: {row: {}, cell: {}}, &block)
    attributes[:row] ||= {}
    attributes[:cell] ||= {}

    tr(attributes[:row]) do
      @data.inject(Builder.new) do |acc, c|
        acc + td(attributes[:cell]) {block_given? ? yield(c) : c}
      end
    end
  end
end

# This needs some reworking, since it's not intuitive
class TableComponent
  include HTMLComponent
  # 2 types:
  #   - 2d-Array table
  #     - column names provided
  #     - outer array contains rows, inner contain cells in their row
  #     - specify if first row contains header or if separate.
  #   - Hash table (from a hash)
  #     - column names derived from keys
  #     - keys associated with columns, each entry in value array is a 
  #         row under the respective column
  #     - header derived from keys
 
  def initialize(header, rows)
    @header = header
    @rows = rows
  end

  # header options:
  # array - use as header
  # symbol - if :from_data, then use first row, if :none, set @header to nil
  def self.from_array(data, header: :none)
    head = rows = nil
    if header == :from_data
      head = data[0]
      rows = data[1..]
    else
      head = header.kind_of?(Array) ? header : nil
      rows = data
    end
    new(head, rows)
  end

  def self.from_hash(data, vertical: true)
    if vertical
      header = data.keys
      rowcount = data.values.map(&:length).max
      rows = [] * rowcount
      data.each do |k,col|
        rowcount.times do |i|
          rows[i] << (i < col.size ? col[i] : nil)
        end
      end
      new(header, rows)
    else
      header = nil
      rows = data.map do |k, v|
        [k] + v
      end
      new(header, rows)
    end
  end

  def render(attributes: {table: {}, header: {}, header_cell: {}, row: {}, cell: {}}, &block)
    # since attributes are complex, ensure all are always valid
    attributes[:table] ||= {}
    attributes[:header] ||= {}
    attributes[:header_cell] ||= {}
    attributes[:row] ||= {}
    attributes[:cell] ||= {}

    table(attributes[:table]) do
      if @header
        tr(attributes[:row].merge(attributes[:header])) do
          @header.inject(Builder.new) do |acc, h|
            acc + th(attributes[:cell].merge(attributes[:header_cell])) {h}
          end
        end
      else
        Builder.new
      end +
      @rows.inject(Builder.new) do |acc, row|
        acc + TableRowComponent.new(row).render(attributes: attributes, &block)
      end
    end
  end
end
