require 'slim'
require 'tailwindcss-rails'
require "importmap-rails"
require "turbo-rails"
require "stimulus-rails"

require 'chartkick'
require 'groupdate'

module Exceptio
  class Engine < ::Rails::Engine
    isolate_namespace Exceptio

    initializer 'exceptio.assets' do |app|
      app.config.assets.paths << root.join("app/javascript")
      app.config.assets.paths << root.join("app/components")
      app.config.assets.paths << Exceptio::Engine.root.join("vendor/javascript")
      app.config.assets.precompile += %w[exceptio_manifest]
    end

    initializer 'exceptio.importmap', before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
      app.config.importmap.cache_sweepers << root.join("app/javascript")
      app.config.importmap.cache_sweepers << root.join("app/components")
      app.config.importmap.cache_sweepers << Exceptio::Engine.root.join("vendor/javascript")
    end
  end
end
