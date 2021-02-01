require "html-native"
require "rails"

# There is no need to alias methods into components or handle existing helper 
# functions as Builders. This is handled by Builder implicitly converting to a string

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
    @strings.join(" ").html_safe
  end
end

module HTMLNativeRails
  def self.call(template, source) 
    source
  end
end

# ActionView::Template.register_template_handler(:rbh, HTMLNativeRails)
require "html-native-rails/railtie" # no if defined? check. I already included "rails"