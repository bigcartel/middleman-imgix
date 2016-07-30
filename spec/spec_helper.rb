require 'rspec'
require 'capybara/rspec'
require 'middleman-core'
require 'middleman-core/rack'
require 'middleman-imgix'

def app(config_rb='')
  ENV['MM_ROOT'] = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', 'app'))
  ENV['MM_ENV'] = 'test'

  config_path = File.join(ENV['MM_ROOT'], 'config.rb')
  File.write(config_path, config_rb)

  mm_app = ::Middleman::Application.new do
    config[:watcher_disable] = true
  end

  Capybara.app = ::Middleman::Rack.new(mm_app).to_app
  File.delete(config_path)

  mm_app
end

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
end
