require "date"
Gem::Specification.new do |s|
  s.name = "html-native-rails"
  s.version = "0.2.1"
  s.date = Date.today.strftime("%Y-%m-%d")
  s.summary = "html-native, but as a Rails template engine"
  s.description = "An html generation DSL designed for fluid code integration. Now with added Rails support!"
  s.homepage = "https://github.com/KellenWatt/html-native/rails"
  s.authors = ["Kellen Watt"]

  s.files = [
    "lib/html-native-rails.rb",
    "lib/html-native-rails/railtie.rb"
  ]

  s.license = "MIT"

  s.add_runtime_dependency("html-native", "~> 0.3")
  s.add_runtime_dependency("rails", "~> 6")
end
