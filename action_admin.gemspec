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
  s.add_development_dependency 'sqlite3'
end
