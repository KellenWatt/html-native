require "html-native"
require "rails"

class ActiveSupport::SafeBuffer
  alias_method :html_component_old_plus, :+
  alias_method :html_component_old_insert, :<<
  alias_method :html_component_old_concat, :concat
  def +(other)
    if other.kind_of? HTMLComponent::Builder
      self.component + other
    else
      self.html_component_old_plus(other)
    end
  end

  def <<(other)
    if other.kind_of? HTMLComponent::Builder
      self.component + other
    else
      self.html_component_old_insert(other)
    end
  end

  def concat(other)
    if other.kind_of? HTMLComponent::Builder
      self.component + other
    else
      self.html_component_old_insert(other)
    end
  end
end

# HTMLComponent is included in ActionView::Base to make sure the HTMLComponent
# methods are available for rendering. 
#
# As a note to my future self, restricting HTMLComponent to be specifically included 
# when the view is first rendered might be a better idea, though I don't quite 
# know how I'd do that right now.
class ActionView::Base
  include HTMLComponent
end


class HTMLComponent::Builder
  # Converts the Builder instance to an HTML-safe String. This does not
  # guarantee the string is valid HTML, just safe.
  def to_s
    unless @cached
      @cache << @strings.join.html_safe
      @strings.clear
      @cached = true
    end
    @cache.html_safe
  end

  # Allows for implicit conversion to html_safe strings
  alias_method :to_str, :to_s
end

module HTMLNativeRails
  def self.call(template, source) 
    source
  end
end

# ActionView::Template.register_template_handler(:rbh, HTMLNativeRails)
require "html-native-rails/railtie" # no if defined? check. I already included "rails"
