require "date"

Gem::Specification.new do |s|
  s.name = "html-native"
  s.version = "0.0.1"
  s.date = Date.today.strftime("%Y-%m-%d")
  s.summary = "Ruby-native html generation"
  s.description = "An html generation DSL designed for fluid code creation."
  s.homepage = "https://github.com/KellenWatt/html-native"
  s.authors = ["Kellen Watt"]

  s.files = [
    "lib/html-native.rb",
    "lib/html-native/lists.rb",
    "lib/html-native/builder.rb"
  ]

  s.license = "MIT"
end
