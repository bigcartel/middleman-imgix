# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = 'middleman-imgix'
  gem.version       = '1.0.3'
  gem.licenses      = ['MIT']
  gem.authors       = ['Big Cartel']
  gem.email         = ['dev@bigcartel.com']
  gem.description   = %q(Use imgix images in your Middleman site.)
  gem.summary       = %q(Run all of your images (or only some) through imgix for all sorts of fun features.)
  gem.homepage      = 'https://github.com/bigcartel/middleman-imgix'

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'middleman-core', '>= 4.1'
  gem.add_runtime_dependency 'imgix', '>= 1.1'
end
