$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'exceptio/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'exceptio'
  s.version     = Exceptio::VERSION
  s.authors     = ['Tom de Grunt']
  s.email       = ['tom@degrunt.nl']
  s.homepage    = 'https://code.entropydecelerator.com/components/exceptio'
  s.summary     = 'Exception logging and management'
  s.description = 'Exception logging and management'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5'

  s.add_development_dependency 'sqlite3'
end
