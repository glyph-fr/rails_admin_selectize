$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'rails_admin_selectize/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'rails_admin_selectize'
  s.version     = RailsAdminSelectize::VERSION
  s.authors     = ['Valentin Ballestrino']
  s.email       = ['vala@glyph.fr']
  s.homepage    = 'http://www.glyph.fr'
  s.summary     = 'Add selectize fields to Rails Admin'
  s.description = 'Add selectize fields to Rails Admin'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 4.0'
  s.add_dependency 'rails_admin', '~> 0.1'
  s.add_dependency 'ransack', '~> 1.2'
  s.add_dependency 'selectize-rails', '~> 0.11'

  s.add_development_dependency 'sqlite3'
end
