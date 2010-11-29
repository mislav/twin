Gem::Specification.new do |gem|
  gem.name    = 'twin'
  gem.version = '0.1.0'
  gem.date    = Date.today.to_s

  gem.add_dependency 'activesupport', '>= 2.3'

  gem.summary = "Twitter's twin"
  gem.description = "Rack middleware to expose a Twitter-like API from your app."

  gem.authors  = ['Mislav Marohnić']
  gem.email    = 'mislav.marohnic@gmail.com'
  gem.homepage = 'http://github.com/mislav/twin'

  gem.rubyforge_project = nil
  gem.has_rdoc = false
  # gem.rdoc_options = ['--main', 'README.rdoc', '--charset=UTF-8']
  # gem.extra_rdoc_files = ['README.rdoc', 'LICENSE', 'CHANGELOG.rdoc']

  gem.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*']
end
