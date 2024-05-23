$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'exceptio/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'exceptio'
  s.version     = Exceptio::VERSION
  s.authors     = ['Tom de Grunt']
  s.email       = ['tom@degrunt.nl']
  s.homepage    = 'https://github.com/entdec/exceptio'
  s.summary     = 'Exception logging and management'
  s.description = 'Exception logging and management'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '> 5.1'

  s.add_development_dependency 'auxilium', '~> 0.2'
  s.add_development_dependency 'sqlite3'
  s.add_dependency 'chartkick'
  s.add_dependency 'groupdate'
  s.add_dependency "slim-rails", "~> 3"
  s.add_dependency 'tailwindcss-rails'
  s.add_dependency 'importmap-rails'
  s.add_dependency 'turbo-rails'
  s.add_dependency 'stimulus-rails'
end
