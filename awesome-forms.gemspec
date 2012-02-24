$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "awesome-forms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "awesome-forms"
  s.version     = AwesomeForms::VERSION
  s.authors     = ["Dyson Simmons"]
  s.email       = ["dyson@dysonsimmons.com.au"]
  s.homepage    = "http://dysonsimons.com"
  s.summary     = "AwesomeForms form builder"
  s.description = "AwesomeForms is a custom form builder for creating forms using the Twitter Bootstrap Markup."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "> 3.1.0"
  # s.add_dependency "jquery-rails"

  # s.add_development_dependency "sqlite3"
end
