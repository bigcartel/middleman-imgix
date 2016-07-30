require 'middleman-core'

class Middleman::Imgix < ::Middleman::Extension
  option :host, nil, 'Your Imgix host.', required: true
  option :secure_url_token, nil, 'Your Imgix secure_url_token.'
  option :use_https, true, 'Whether to use http or https for Imgix.'
  option :shard_strategy, :crc, 'Your Imgix shard strategy.'
  option :include_library_param, true, 'Include the Imgix library param in each URL.'
  option :default_params, { auto: 'format' }, 'Default Imgix params to use on all images.'
  option :fluid_img_tags, true, 'Whether to use data-src and apply Imgix classes to img tags.'
  option :fluid_img_classes, 'imgix-fluid', 'CSS classes to append to Imgix img tags.'
  option :exts, %w(.png .jpg .jpeg), 'List of file extensions that get converted to Imgix URLs.'
  option :sources, %w(.css .htm .html .js .php .xhtml), 'List of source extensions that are searched for Imgix images.'
  option :ignore, [], 'Regexes of filenames to skip adding Imgix to'
  option :rewrite_ignore, [], 'Regexes of filenames to skip processing for path rewrites'

  expose_to_template imgix_options: :options

  def initialize(app, options_hash={}, &block)
    super

    app.rewrite_inline_urls id: :imgix,
                            url_extensions: options.exts,
                            source_extensions: options.sources,
                            ignore: options.ignore,
                            rewrite_ignore: options.rewrite_ignore,
                            proc: method(:rewrite_url)

    require 'imgix'
  end

  def rewrite_url(asset_path, dirpath, _request_path)
    uri = URI.parse(asset_path)

    if uri.relative?
      params = CGI::parse(uri.query.to_s)
      params = params.reverse_merge(options.default_params)
      path = client.path(uri.path)
      path.to_url(params)
    else
      asset_path
    end
  end
  memoize :rewrite_url

  helpers do
    def image_tag(path, params={})
      if imgix_options.fluid_img_tags && imgix_image?(path)
        params[:class] = params[:class].to_s.split(' ').push(imgix_options.fluid_img_classes).join(' ')
        super(path, params).gsub('src=', 'data-src=')
      else
        super
      end
    end

    def imgix_image?(path)
      uri = URI.parse(path)
      uri.relative? &&
      imgix_options.exts.include?(::File.extname(uri.path)) &&
      imgix_options.sources.include?(::File.extname(current_resource.path)) &&
      imgix_options.ignore.none? { |r| ::Middleman::Util.should_ignore?(r, uri.path) } &&
      imgix_options.rewrite_ignore.none? { |i| ::Middleman::Util.path_match(i, uri.path) }
    end
  end

  private

  def client
    @client ||= Imgix::Client.new({
      host: options.host,
      secure_url_token: options.secure_url_token,
      use_https: options.use_https,
      shard_strategy: options.shard_strategy,
      include_library_param: options.include_library_param
    })
  end
end
