# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'action_admin/version'

Gem::Specification.new do |s|
  s.name        = 'action_admin'
  s.version     = ActionAdmin::VERSION
  s.authors     = ['Jonian Guveli']
  s.email       = ['jonian@hardpixel.eu']
  s.summary     = 'Ruby on Rails mountable engine to create admin interfaces'
  s.description = 'Ruby on Rails mountable engine to create admin interfaces.'
  s.homepage    = 'https://github.com/hardpixel/action-admin'
  s.license     = 'MIT'
  s.files       = Dir['{app,config,db,lib}/**/*', 'LICENSE.txt', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1'
  s.add_dependency 'slim', '~> 3.0'
  s.add_dependency 'hashie', '~> 3.5'
  s.add_dependency 'bedrock_sass', '~> 0.1'
  s.add_dependency 'action_crud', '~> 0.1'
  s.add_dependency 'simple_form', '~> 3.5'
  s.add_dependency 'simple_attribute', '~> 0.1'
  s.add_dependency 'smart_navigation', '~> 0.1'
  s.add_dependency 'smart_pagination', '~> 0.2'
  s.add_dependency 'meta-tags', '~> 2.6'

  s.add_development_dependency 'sqlite3'
end
