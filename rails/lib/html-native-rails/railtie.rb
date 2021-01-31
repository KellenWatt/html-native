module HTMLNativeRails
  class Railtie < Rails::Railtie
    initializer "html_native_rails.add_html_native_template_handler" do
      ActionView::Template.register_template_handler(:rbh, HTMLNativeRails)
    end
  end
end
