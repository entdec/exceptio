# frozen_string_literal: true

desc 'Release a new version'
namespace :exceptio do
  task :release do
    version_file = './lib/exceptio/version.rb'
    File.open(version_file, 'w') do |file|
      file.puts <<~EOVERSION
        # frozen_string_literal: true

        module Exceptio
          VERSION = '#{Exceptio::VERSION.split('.').map(&:to_i).tap { |parts| parts[2] += 1 }.join('.')}'
        end
      EOVERSION
    end
    module Exceptio
      remove_const :VERSION
    end
    load version_file
    puts "Updated version to #{Exceptio::VERSION}"

    `git commit lib/exceptio/version.rb -m "Version #{Exceptio::VERSION}"`
    `git push`
    `git tag #{Exceptio::VERSION}`
    `git push --tags`
  end
end
