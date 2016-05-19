# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = 'middleman-imgix'
  gem.version       = '0.0.1'
  gem.authors       = ['Big Cartel']
  gem.email         = ['dev@bigcartel.com']
  gem.description   = %q(Use Imgix images in your Middleman site.)
  gem.summary       = %q(Have all images (or only some) go through Imgix for all sorts of fun features.)

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'middleman-core', '>= 4.1.8'
end
