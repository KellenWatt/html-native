require "html-native"
require "html-native/builder"

module Enumerable
  # Maps the given block to each element of *enum*. The result of each iteration
  # is added to an HTMLComponent::Builder instance, which is returned after the
  # final iteration.
  #
  # If no block is given, an enumerator is returned instead.
  def component_map 
    if block_given?
      result = HTMLComponent::Builder.new
      each do |e|
        result += yield(e)
      end
      result
    else
      to_enum(:component_map)
    end
  end

  # Returns an OrderedListComponent representing the *enum*.
  # 
  # See OrderedListComponent#new for details on how to apply attributes.
  def to_ol(attributes: {})
    OrderedListComponent.new(self, attributes: attributes)
  end
  
  # Returns an UnorderedListComponent representing the *enum*.
  # 
  # See UnorderedListComponent#new for details on how to apply attributes.
  def to_ul(attributes: {})
    UnorderedListComponent.new(self, attributes: attributes)
  end
end

# OrderedListComponent represents an HTML ordered list based on an Enumerable
# collection.
class OrderedListComponent
  include HTMLComponent

  # Creates a new instance of OrderedListComponent from the values of `data`.
  # 
  # Additional attributes can be provided by passing a Hash to the keyword 
  # argument `attributes`. The attributes are split into multiple categories 
  # which are listed below: 
  # - *list* - The attributes associated with the <ol> tag.
  # - *item* - The attributes associated with <li> tags. 
  #
  # For example, to have a list with 20px padding and the class of "list-item" 
  # given to each item, you could write:
  # ```
  # OrderedListComponent.new(data, attributes: 
  #   {list: {style: "padding: 20px"}, item: {class: "list-item"}})
  #
  # # Is equivalent to
  # # <ol style="padding: 20px">
  # #   <li class="list-item">...</li>
  # #   <li class="list-item">...</li>
  # #   ...
  # # </ol>
  # ```
  def initialize(data, attributes: {}, &block)
    @list_data = data
    @list_attributes = attributes[:list] || {}
    @item_attributes = attributes[:item] || {}
    @block = block
  end

  def render
    ol(@list_attributes) do
      @list_data.component_map do |l|
        li(@item_attributes) do
          @block ? @block.call(l) : l
        end
      end
    end
  end
end

class UnorderedListComponent
  include HTMLComponent

  def initialize(data, attributes: {}, &block)
    @list_data = data
    @list_attributes = attributes[:list] || {}
    @item_attributes = attributes[:item] || {}
    @block = block
  end

  def render
    ul(@list_attributes) do
      @list_data.component_map do |l|
        li(@item_attributes) do
          @block ? @block.call(l) : l
        end
      end
    end
  end
end

class ListComponent
  def initialize(data, attributes: {}, ordered: false, &block)
    @list = ordered ? OrderedListComponent.new(data, attributes, &block) : 
                      UnorderedListComponent.new(data, attributes, &block)
  end

  def render
    @list.render
  end
end

class TableRowComponent
  include HTMLComponent

  def initialize(data, attributes: {}, &block)
    @data = data
    @row_attributes = attributes[:row] || {}
    @cell_attributes = attributes[:cell] || {}
    @block = block
  end

  def render
    tr(@row_attributes) do
      @data.component_map do |c|
        td(@cell_attributes) {@block ? @block.call(c) : c}
      end
    end
  end
end

# This needs some reworking, since it's not intuitive
class TableComponent
  include HTMLComponent

  def initialize(header, rows, attributes: {}, &block)
    @header = header
    @rows = rows
    @table_attributes = attributes[:table] || {}
    @header_attributes = attributes[:header] || {}
    @header_cell_attributes = attributes[:header_cell] || {}
    @row_attributes = attributes[:row] || {}
    @cell_attributes = attributes[:cell] || {}
    @block = block
  end

  # header options:
  # array - use as header
  # symbol - if :from_data, then use first row, if :none, set @header to nil
  def self.from_array(data, attributes: {}, header: :none, &block)
    head = rows = nil
    if header == :from_data
      head = data[0]
      rows = data[1..]
    else
      head = header.kind_of?(Array) ? header : nil
      rows = data
    end
    new(head, rows, attributes: attributes, &block)
  end

  def self.from_hash(data, attributes: {}, vertical: true, &block)
    if vertical
      rowcount = data.values.map(&:length).max
      rows = [] * rowcount
      data.each do |k,col|
        rowcount.times do |i|
          rows[i] << (i < col.size ? col[i] : nil)
        end
      end
      new(data.keys, rows, attributes: attributes, &block)
    else
      rows = data.map do |k, v|
        [k] + v
      end
      new(nil, rows, attributes: attributes, &block)
    end
  end

  def render
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
        attributes = {row: @row_attributes, cell: @cell_attributes}
        TableRowComponent.new(row, attributes: attributes, &@block)
      end
    end
  end
end

class DropdownComponent
  include HTMLComponent

  def initialize(choices, name, attributes: {}, &block)
    @choices = choices
    @name = name
    @menu_attributes = attributes[:menu]
    @item_attributes = attributes[:item]
    @block = block
  end

  def render
    select(@menu_attributes.merge({name: @name, id: "#{@name}-dropdown"})) do
      @choices.component_map do |c|
        option(@item_attributes.merge({value: c})) {@block ? @block.call(c) : c}
      end
    end
  end
end

class RadioGroupComponent
  include HTMLComponent

  def initialize(choices, name, attributes: {}, labelled: true, &block)
    @choices = choices
    @name = name
    @button_attributes = attributes[:button]
    @label_attributes = attributes[:label]
    @labelled = labelled
    @block = block
  end

  def render
    @choices.component_map do |c|
      id = "#{@name}-#{c}" 
      input({type: "radio", id: id, name: @name, value: c}) +
        (@labelled ? (label({for: id}) {@block ? @block.call(c) : c}) : nil)
    end
  end
end
