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
#
# Attributes in an OrderedListComponent are separated into multiple groups since
# there are multiple kinds of tags. These groups are:
# - list - The attributes associated with the <ol> element
# - item - The attributes associated with <li> elements
#
# For example, to have a list with 20px padding and the class of "list-item" 
# given to each item, you could write:
# ```
# OrderedListComponent.new(data, attributes: 
#   {list: {style: "padding: 20px"}, item: {class: "list-item"}})
#
# ```
# which is equivalent to
# ```
# <ol style="padding: 20px">
#   <li class="list-item">...</li>
#   <li class="list-item">...</li>
#   ...
# </ol>
# ```
class OrderedListComponent
  include HTMLComponent

  # Creates a new instance of OrderedListComponent from the values of *data*.
  #
  # If a block is given, each item in *data* is passed to it to render the list
  # items. If no block is given, *data* are used directly.
  def initialize(data, attributes: {}, &block)
    @list_data = data
    @list_attributes = attributes[:list] || {}
    @item_attributes = attributes[:item] || {}
    @block = block
  end

  # Converts the OrderedListComponent instance to the equivalent HTML. 
  #
  # *render* can be called directly, but that usually isn't necessary.
  # HTMLComponent::Builder handles this automatically, so it only needs to be 
  # done if there is no prior instance of one.
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

# UnorderedListComponent represents an HTML unordered list generated from an 
# Enumerable collection.
#
# Attributes in an UnorderedListComponent are separated into multiple groups since
# there are multiple kinds of tags. These groups are:
# - list - The attributes associated with the <ul> element
# - item - The attributes associated with <li> elements
#
# For example, to have a list with 20px padding and the class of "list-item" 
# given to each item, you could write:
# ```
# UnorderedListComponent.new(data, attributes: 
#   {list: {style: "padding: 20px"}, item: {class: "list-item"}})
#
# ```
# which is equivalent to
# ```
# <ul style="padding: 20px">
#   <li class="list-item">...</li>
#   <li class="list-item">...</li>
#   ...
# </ul>
# ```
class UnorderedListComponent
  include HTMLComponent

  # Creates a new instance of UnorderedListComponent from the values of *data*.
  #
  # If a block is given, each item in *data* is passed to it to render the list
  # items. If no block is given, *data* are used directly.
  def initialize(data, attributes: {}, &block)
    @list_data = data
    @list_attributes = attributes[:list] || {}
    @item_attributes = attributes[:item] || {}
    @block = block
  end

  # Converts the UnorderedListComponent instance to the equivalent HTML. 
  #
  # *render* can be called directly, but that usually isn't necessary.
  # HTMLComponent::Builder handles this automatically, so it only needs to be 
  # done if there is no prior instance of one.
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

# ListComponent represents an HTML list based on an Enumerable collection.
#
# Attributes in an ListComponent are separated into multiple groups since
# there are multiple kinds of tags. These groups are:
# - list - The attributes associated with the <ul> element
# - item - The attributes associated with <li> elements
#
# For example, to have an ordered list with 20px padding and the class of 
# "list-item" given to each item, you could write:
# ```
# ListComponent.new(data, ordered: true, attributes: 
#   {list: {style: "padding: 20px"}, item: {class: "list-item"}})
#
# ```
# which is equivalent to
# ```
# <ol style="padding: 20px">
#   <li class="list-item">...</li>
#   <li class="list-item">...</li>
#   ...
# </ol>
# ```
class ListComponent
  # Creates a new instance of ListComponent from the values of *data*.
  # 
  # This list can be either ordered or unordered, depending on *ordered* parameter.
  # If *ordered* is true, the list will be ordered, otherwise it will be unordered.
  # *ordered* is false by default.
  #
  # If a block is given, each item in *data* is passed to it to render the list
  # items. If no block is given, *data* are used directly.
  def initialize(data, attributes: {}, ordered: false, &block)
    @list = ordered ? OrderedListComponent.new(data, attributes, &block) : 
                      UnorderedListComponent.new(data, attributes, &block)
  end

  # Converts the ListComponent instance to the equivalent HTML. 
  #
  # *render* can be called directly, but that usually isn't necessary.
  # HTMLComponent::Builder handles this automatically, so it only needs to be 
  # done if there is no prior instance of one.
  def render
    @list.render
  end
end

# TableRowComponent represents an HTML table row generated from an 
# Enumerable collection.
#
# Attributes in an TableRowComponent are separated into multiple groups since
# there are multiple kinds of tags. These groups are:
# - row - The attributes associated with the <tr> element
# - cell - The attributes associated with <td> elements
#
# For example, to have a row with 20px padding and the class of "table-cell" 
# given to each cell, you could write:
# ```
# TableRowComponent.new(data, attributes: 
#   {row: {style: "padding: 20px"}, cell: {class: "list-item"}})
#
# ```
# which is equivalent to
# ```
# <tr style="padding: 20px">
#   <td class="list-item">...</td>
#   <td class="list-item">...</td>
#   ...
# </tr>
# ```
class TableRowComponent
  include HTMLComponent

  # Creates a new instance of TableRowComponent from the values of *data*.
  #
  # If a block is given, each item in *data* is passed to it to render the row
  # cells. If no block is given, *data* are used directly.
  def initialize(data, attributes: {}, &block)
    @data = data
    @row_attributes = attributes[:row] || {}
    @cell_attributes = attributes[:cell] || {}
    @block = block
  end

  # Converts the TableRowComponent instance to the equivalent HTML. 
  #
  # *render* can be called directly, but that usually isn't necessary.
  # HTMLComponent::Builder handles this automatically, so it only needs to be 
  # done if there is no prior instance of one.
  def render
    tr(@row_attributes) do
      @data.component_map do |c|
        td(@cell_attributes) {@block ? @block.call(c) : c}
      end
    end
  end
end

# TableComponent represents an HTML table generated from an Enumerable 
# collection.
#
# Attributes in an TableComponent are separated into multiple groups since
# there are multiple kinds of tags. These groups are:
# - table - The attributes associated with the <table> element.
# - header - The attributes associated with <tr> element representing the header.
# - header_cell - The attributes associated with <th> elements.
# - row - The attributes associated with all <tr> elements, including the header.
# - cell - The attributes associated with <td> and <th> elements.
#
# Refer to other components for the format for applying attributes.
class TableComponent
  include HTMLComponent

  # Creates a new instance of TableComponent from the values of *rows*.
  #
  # *rows* is an Enumerable collection of Enumerable objects.
  #
  # If a block is given, each item in *rows* is passed to it to render the table
  # cells, not including the header. If no block is given, *rows* is used directly.
  def initialize(rows, col_names: [], row_names: [], attributes: {}, &block)
    @rows = rows.map(&:to_a)
    @header = col_names.to_a
    row_names = row_names.to_a
    unless row_names.empty?
      row_names.each_with_index do |name, i|
        if i < @rows.size
          @rows[i].prepend(name) 
        else
          @rows << [name]
        end
      end
    end
    @header.prepend("") unless row_names.empty? || @header.empty?

    @table_attributes = attributes[:table] || {}
    @header_attributes = attributes[:header] || {}
    @header_cell_attributes = attributes[:header_cell] || {}
    @row_attributes = attributes[:row] || {}
    @cell_attributes = attributes[:cell] || {}
    @block = block
  end

  # Converts the TableComponent instance to the equivalent HTML. 
  #
  # *render* can be called directly, but that usually isn't necessary.
  # HTMLComponent::Builder handles this automatically, so it only needs to be 
  # done if there is no prior instance of one.
  def render
    table(@table_attributes) do
      unless @header.empty?
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

# DropdownComponent represents an HTML table row generated from an 
# Enumerable collection.
#
# Attributes in an DropdownComponent are separated into multiple groups since
# there are multiple kinds of tags. These groups are:
# - menu - The attributes associated with the <select> element
# - item - The attributes associated with <option> elements
class DropdownComponent
  include HTMLComponent

  # Creates a new instance of DropdownComponent from the values of *choices*.
  #
  # If a block is given, each item in *choices* is passed to it to render the
  # item. If no block is given, *choices* is used directly.
  def initialize(choices, name, attributes: {}, &block)
    @choices = choices
    @name = name
    @menu_attributes = attributes[:menu]
    @item_attributes = attributes[:item]
    @block = block
  end

  # Converts the DropdownComponent instance to the equivalent HTML. 
  #
  # *render* can be called directly, but that usually isn't necessary.
  # HTMLComponent::Builder handles this automatically, so it only needs to be 
  # done if there is no prior instance of one.
  def render
    select(@menu_attributes.merge({name: @name, id: "#{@name}-dropdown"})) do
      @choices.component_map do |c|
        option(@item_attributes.merge({value: c})) {@block ? @block.call(c) : c}
      end
    end
  end
end

# RadioGroupComponent represents an HTML radio button group generated from an 
# Enumerable collection.
#
# Each item has a unique id of the form of `"#{name}-{choice}"`, where name is 
# the provided *name* option, and choice is value of that button. 
#
# Each item produces a button and a label.
#
# Attributes in an RadioGroupComponent are separated into multiple groups since
# there are multiple kinds of tags. These groups are:
# - button - The attributes associated with the <input type: "radio"> elements.
# - label - The attributes associated with <label> elements.
class RadioGroupComponent
  include HTMLComponent

  # Creates a new instance of RadioGroupComponent from the values of *choices*.
  #
  # If a block is given, each item in *choices* is passed to it to render the
  # label. If no block is given, *choices* is used directly.
  def initialize(choices, name, attributes: {}, labelled: true, &block)
    @choices = choices
    @name = name
    @button_attributes = attributes[:button]
    @label_attributes = attributes[:label]
    @labelled = labelled
    @block = block
  end

  # Converts the RadioGroupComponent instance to the equivalent HTML. 
  #
  # *render* can be called directly, but that usually isn't necessary.
  # HTMLComponent::Builder handles this automatically, so it only needs to be 
  # done if there is no prior instance of one.
  def render
    @choices.component_map do |c|
      id = "#{@name}-#{c}" 
      input({type: "radio", id: id, name: @name, value: c}) +
        (@labelled ? (label({for: id}) {@block ? @block.call(c) : c}) : nil)
    end
  end
end
