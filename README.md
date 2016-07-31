# middleman-imgix [![Build Status](https://travis-ci.org/bigcartel/middleman-imgix.svg?branch=master)](https://travis-ci.org/bigcartel/middleman-imgix) [![Gem Version](https://badge.fury.io/rb/middleman-imgix.svg)](https://badge.fury.io/rb/middleman-imgix)

`middleman-imgix` is an extension for the [Middleman](https://middlemanapp.com) static site generator that allows you to run all of your images (or only some) through [imgix](https://www.imgix.com) for all sorts of fun features.

## Installation

From inside the Gemfile of your Middleman project | add:

```
gem 'middleman-imgix'
```

Then run `bundle install`

## Configuration

Activate the extension in your `config.rb` file, and supply your required imgix host:

```
activate :imgix, host: 'your-subdomain.imgix.net'
```

A number of other options are supported as well (see the [imgix gem](https://github.com/imgix/imgix-rb) for more info):

```
activate :imgix, host: 'your-subdomain.imgix.net', secure_url_token: 'your-token', shard_strategy: :cycle
```

Here's a list of all available options:

| Option  | Default | Description |
| ------------- | ------------- | ------------- |
| `host` (required) | `nil` | A string or array of your imgix hosts. |
| `secure_url_token` | `nil` | Your imgix [secure_url_token](https://docs.imgix.com/setup/securing-images). |
| `use_https` | `true` | Whether to use http or https for imgix. |
| `shard_strategy` | `:crc` | Your imgix [shard strategy](https://github.com/imgix/imgix-rb#domain-sharded-urls). |
| `include_library_param` | `true` | Include the imgix [library param](https://github.com/imgix/imgix-rb#what-is-the-ixlib-param-on-every-request) in each URL. |
| `default_params` | `{ auto: 'format' }` | Default [imgix params](https://docs.imgix.com/apis/url) to use on all images. |
| `imgix_js_version` | `nil` | Converts `image_tag`s to support [imgix.js](https://www.imgix.com/imgix-js) version [2](https://github.com/imgix/imgix.js/tree/master-2.x) or [3](https://github.com/imgix/imgix.js). |
| `exts` | `%w(.png .jpg .jpeg)` | List of file extensions that get converted to imgix URLs. |
| `sources` | `%w(.css .htm .html .js .php .xhtml)` | List of source extensions that are searched for imgix images. |
| `ignore` | `[]` | Regexes of filenames to skip adding imgix to. |
| `rewrite_ignore` | `[]` | Regexes of filenames to skip processing for path rewrites. |

## Usage

After activating the extension, all applicable image URLs throughout your site (HTML, CSS, etc.) will begin pointing to imgix. For example...

```ruby
image_tag 'example.png'
#=> <img src="https://your-subdomain.imgix.net/images/example.png?ixlib=rb-1.1.0&auto=format" />
```

### imgix.js

If you're using [imgix.js](https://www.imgix.com/imgix-js) for responsive images (you still need to include that JS file yourself), you can [configure](#configuration) the `imgix_js_version` option to have the output from `image_tag` generate specific markup for your imgix.js version.

#### imgix_js_version: 3

```ruby
image_tag 'example.png'
#=> <img ix-src="https://your-subdomain.imgix.net/images/example.png?ixlib=rb-1.1.0&auto=format" />
```

#### imgix_js_version: 2

```ruby
image_tag 'example.png'
#=> <img data-src="https://your-subdomain.imgix.net/images/example.png?ixlib=rb-1.1.0&auto=format" class="imgix-fluid" />
```
