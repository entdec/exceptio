# frozen_string_literal: true

module Exceptio
  class BacktraceEnrichmentService < ApplicationService
    attr_reader :backtrace
    delegate :gems_data, to: :class

    def initialize(backtrace)
      @backtrace = backtrace.is_a?(Array) ? backtrace : backtrace.split("\n")
    end

    def perform
      backtrace.map { |line| line_details(line) }
    end

    def line_details(line)
      data = gem_data_for(line)
      data ||= extract_data_for(line)

      data[:file], data[:line], data[:method] = data.delete(:local_path).split(':', 3)
      data[:method] = data[:method]&.gsub('in `', '')&.gsub("'", '')
      data[:full_line] = line
      data
    end

    # Find the relevant gem information
    def gem_data_for(line)
      gem_path = gems_data.keys.find { |gem_path| gem_path.starts_with?('/') ? line.starts_with?(gem_path) : line.include?(gem_path)}
      gem_data = gems_data[gem_path].dup
      gem_data[:local_path] = line.gsub(%r{.*#{gem_path}\/?}, '') if gem_data
      gem_data
    end

    # Extract info from line when gem data is missing
    def extract_data_for(line)
      if line =~ /\([a-zA-Z_]+\)/
        { name: line.split('(', 2).last.split(')').first, version: '', local_path: line }
      else
        { name: '(unkown)', version: '', local_path: line }
      end
    end

    class << self
      # Retrieve data about bundled gems, ruby and the rails app
      def gems_data
        return @gems if @gems

        @gems = {}
        @gems = Bundler.load.gems.map { |gem| [gem.full_gem_path, { name: gem.name, version: gem.version.to_s }] }.to_h
        @gems[Bundler.ruby_scope.to_s] = { name: 'Ruby', version: RUBY_VERSION }
        @gems[Rails.root.to_s] = { name: Rails.application.class.name, version: `git rev-parse --short HEAD`.chomp }
        @gems['./'] = { name: Rails.application.class.name, version: `git rev-parse --short HEAD`.chomp }
        @gems
      rescue StandardError
        @gems
      end
    end
  end
end
