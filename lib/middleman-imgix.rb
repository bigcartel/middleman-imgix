require 'middleman-core'

Middleman::Extensions.register :imgix do
  require 'middleman-imgix/extension'
  Middleman::Imgix
end
