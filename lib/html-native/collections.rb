require "html-native"
require "html-native/builder"

module Enumerable
  def component_map 
    if block_given?
      result = Builder.new
      each do |e|
        result += yield(e)
      end
      result
    else
      to_enum(:component_map)
    end
  end

  def to_ol(attributes: {})
    OrderedListComponent.new(self, attributes: attributes)
  end
  
  def to_ul(attributes: {})
    UnorderedListComponent.new(self, attributes: attributes)
  end
end

class OrderedListComponent
  include HTMLComponent

  def initialize(data, attributes: {})
    @list_data = data
    @list_attributes = attributes[:list] || {}
    @item_attributes = attributes[:item] || {}
  end

  def render(&block)
    ol(@list_attributes) do
      @list_data.component_map do |l|
        li(@item_attributes) do
          block_given? ? yield(l) : l.to_s
        end
      end
    end
  end
end

class UnorderedListComponent
  include HTMLComponent

  def initialize(data, attributes: {})
    @list_data = data
    @list_attributes = attributes[:list] || {}
    @item_attributes = attributes[:item] || {}
  end

  def render(&block)
    ul(@list_attributes) do
      @list_data.component_map do |l|
        li(@item_attributes) do
          block_given? ? yield(l) : l.to_s
        end
      end
    end
  end
end

class ListComponent
  def initialize(data, attributes: {}, ordered: false)
    @list = ordered ? OrderedListComponent.new(data, attributes) : 
                      UnorderedListComponent.new(data, attributes)
  end

  def render(&block)
    @list.render(&block)
  end
end

class TableRowComponent
  include HTMLComponent

  def initialize(data, attributes: {})
    @data = data
    @row_attributes = attributes[:row] || {}
    @cell_attributes = attributes[:cell] || {}
  end

  def render(&block)
    tr(@row_attributes) do
      @data.component_map |c|
        td(@cell_attributes) {block_given? ? yield(c) : c}
      end
    end
  end
end

# This needs some reworking, since it's not intuitive
class TableComponent
  include HTMLComponent

  def initialize(header, rows, attributes: {})
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
  def self.from_array(data, attributes: {}, header: :none)
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

  def self.from_hash(data, attributes: {}, vertical: true)
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
          @header.component_map do |h|
            th(@cell_attributes.merge(@header_cell_attributes)) {h}
          end
        end
      else
        Builder.new
      end +
      @rows.component_map do |row|
        TableRowComponent.new(row, attributes: {row: @row_attributes, cell: @cell_attributes}).render(&block)
      end
    end
  end
end

class DropdownComponent
  include HTMLComponent

  def initialize(choices, name, attributes: {})
    @choices = choices
    @name = name
    @menu_attributes = attributes[:menu]
    @item_attributes = attributes[:item]
  end

  def render(&block)
    select(@menu_attributes.merge({name: @name, id: "#{@name}-dropdown"})) do
      @choices.component_map |c|
        option(@item_attributes.merge({value: c})) {block_given? ? yield(c) : c}
      end
    end
  end
end

class RadioGroupComponent
  include HTMLComponent

  def initialize(choices, name, attributes: {}, labelled: true)
    @choices = choices
    @name = name
    @button_attributes = attributes[:button]
    @label_attributes = attributes[:label]
    @labelled = labelled
  end

  def render(&block)
    @choices.component_map do |c|
      id = "#{@name}-#{c}" 
      input({type: "radio", id: id, name: @name, value: c}) +
        (@labelled ? (label({for: id}) {block_given? ? yield(c) : c}) : nil)
    end
  end
end
