require 'spec_helper'

describe "middleman-imgix", type: :feature do
  def visit_app(config='host: "images.example.com"')
    app("activate :imgix, #{config}")
    visit '/imgix.html'
  end

  describe "host" do
    it "should raise an error if missing" do
      expect { app('activate :imgix') }.to raise_error
    end

    it "can be set to a single host" do
      visit_app
      expect(page.body).to include('images.example.com')
    end

    it "can be set to multiple hosts" do
      visit_app('host: ["images1.example.com", "images2.example.com"]')
      expect(page.body).to include('images1.example.com')
      expect(page.body).to include('images2.example.com')
    end
  end

  describe "secure_url_token" do
    it "should be nil by default" do
      visit_app
      expect(page.body).to_not include('&s=')
    end

    it "should work when set" do
      visit_app('host: "images.example.com", secure_url_token: "test"')
      expect(page.body).to include('&s=c2708015f12eae21de4d0e6cc55f525e')
    end
  end

  describe "use_https" do
    it "should be true by default" do
      visit_app
      expect(page.body).to include('https://')
    end

    it "should work when false" do
      visit_app('host: "images.example.com", use_https: false')
      expect(page.body).to include('http://')
    end
  end

  describe "shard_strategy" do
    it "should be crc by default" do
      visit_app('host: ["1.example.com", "2.example.com", "3.example.com"]')
      expect(page.body).to eq(%{<img src="https://2.example.com/images/test.png?ixlib=rb-1.1.0&auto=format" alt="Test" />\n<img src="https://2.example.com/images/test.jpg?ixlib=rb-1.1.0&auto=format" alt="Test" />\n<img src="/images/test.gif" alt="Test" />\n})
    end

    it "should work when cycle" do
      visit_app('host: ["1.example.com", "2.example.com", "3.example.com"], shard_strategy: :cycle')
      expect(page.body).to eq(%{<img src="https://1.example.com/images/test.png?ixlib=rb-1.1.0&auto=format" alt="Test" />\n<img src="https://2.example.com/images/test.jpg?ixlib=rb-1.1.0&auto=format" alt="Test" />\n<img src="/images/test.gif" alt="Test" />\n})
    end
  end

  describe "include_library_param" do
    it "should be true by default" do
      visit_app
      expect(page.body).to include('ixlib=rb-1.1.0')
    end

    it "should work when set" do
      visit_app('host: "images.example.com", include_library_param: false')
      expect(page.body).to_not include('ixlib=rb-1.1.0')
    end
  end

  describe "default_params" do
    it "should be auto format by default" do
      visit_app
      expect(page.body).to include('auto=format')
    end

    it "should work when customized" do
      visit_app('host: "images.example.com", default_params: {fit:"max"}')
      expect(page.body).to_not include('auto=format')
      expect(page.body).to include('fit=max')
    end
  end

  describe "imgix_js_version" do
    it "should not use imgix.js default" do
      visit_app
      expect(page.body).to include(%{<img src="https://images.example.com/images/test.png?ixlib=rb-1.1.0&auto=format" alt="Test" />})
    end

    it "should support imgix.js v2" do
      visit_app('host: "images.example.com", imgix_js_version: 2')
      expect(page.body).to include(%{<img data-src="https://images.example.com/images/test.png?ixlib=rb-1.1.0&auto=format" class="imgix-fluid" alt="Test" />})
    end

    it "should support imgix.js v3" do
      visit_app('host: "images.example.com", imgix_js_version: 3')
      expect(page.body).to include(%{<img ix-src="https://images.example.com/images/test.png?ixlib=rb-1.1.0&auto=format" alt="Test" />})
    end
  end

  describe "exts" do
    it "should be pngs and jpgs by default" do
      visit_app
      expect(page.body).to eq(%{<img src="https://images.example.com/images/test.png?ixlib=rb-1.1.0&auto=format" alt="Test" />\n<img src="https://images.example.com/images/test.jpg?ixlib=rb-1.1.0&auto=format" alt="Test" />\n<img src="/images/test.gif" alt="Test" />\n})
    end

    it "should work when customized" do
      visit_app('host: "images.example.com", exts: %w(.png .jpg .jpeg .gif)')
      expect(page.body).to eq(%{<img src="https://images.example.com/images/test.png?ixlib=rb-1.1.0&auto=format" alt="Test" />\n<img src="https://images.example.com/images/test.jpg?ixlib=rb-1.1.0&auto=format" alt="Test" />\n<img src="https://images.example.com/images/test.gif?ixlib=rb-1.1.0&auto=format" alt="Test" />\n})
    end
  end

  describe "sources" do
    it "should be html, js, and css by default" do
      visit_app
      expect(page.body).to include(%'images.example.com')
    end

    it "should work when customized" do
      visit_app('host: "images.example.com", sources: %w(.css)')
      expect(page.body).to_not include(%'images.example.com')
    end
  end

  describe "ignore" do
    it "should not ignore anything by default" do
      visit_app
      expect(page.body).to include(%'images.example.com/images/test.png')
    end

    it "should work when customized" do
      visit_app('host: "images.example.com", ignore: %w(/images/test.png)')
      expect(page.body).to_not include(%'images.example.com/images/test.png')
      expect(page.body).to include(%'/images/test.png')
    end
  end

  describe "rewrite_ignore" do
    it "should not ignore anything by default" do
      visit_app
      expect(page.body).to include(%'images.example.com/images/test.png')
    end

    it "should work when customized" do
      visit_app('host: "images.example.com", rewrite_ignore: %w(/imgix.html)')
      expect(page.body).to_not include(%'images.example.com/images/test.png')
      expect(page.body).to include(%'/images/test.png')
    end
  end
end
