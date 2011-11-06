# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name    = 'twin'
  gem.version = '0.1.3'

  gem.add_dependency 'activesupport', '>= 2.3'

  gem.summary = "Twitter's twin"
  gem.description = "Rack middleware to expose a Twitter-like API in your app."

  gem.authors  = ['Mislav Marohnić']
  gem.email    = 'mislav.marohnic@gmail.com'
  gem.homepage = 'http://github.com/mislav/twin'

  gem.rubyforge_project = nil

  gem.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*']
end
