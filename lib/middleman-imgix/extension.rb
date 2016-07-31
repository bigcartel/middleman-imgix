require 'middleman-core'

class Middleman::Imgix < ::Middleman::Extension
  option :host, nil, 'Your imgix host.', required: true
  option :secure_url_token, nil, 'Your imgix secure_url_token.'
  option :use_https, true, 'Whether to use http or https for imgix.'
  option :shard_strategy, :crc, 'Your imgix shard strategy.'
  option :include_library_param, true, 'Include the imgix library param in each URL.'
  option :default_params, { auto: 'format' }, 'Default imgix params to use on all images.'
  option :imgix_js_version, nil, 'Converts image_tags to support imgix.js version 2 or 3.'
  option :exts, %w(.png .jpg .jpeg), 'List of file extensions that get converted to imgix URLs.'
  option :sources, %w(.css .htm .html .js .php .xhtml), 'List of source extensions that are searched for imgix images.'
  option :ignore, [], 'Regexes of filenames to skip adding imgix to.'
  option :rewrite_ignore, [], 'Regexes of filenames to skip processing for path rewrites.'

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
      if imgix_options.imgix_js_version && imgix_image?(path)
        version = imgix_options.imgix_js_version.to_i
        params[:class] = 'imgix-fluid' if version == 2
        src = version == 2 ? 'data-src=' : 'ix-src='
        super(path, params).gsub('src=', src)
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
