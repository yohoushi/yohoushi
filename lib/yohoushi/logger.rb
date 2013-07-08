require 'logger'
require 'yaml'
ENV['RAILS_ENV'] ||= 'development'
ENV['RAILS_ROOT'] ||= File.expand_path('../../..', __FILE__)

module Yohoushi
  module_function

  # Create a logger instance
  #
  # @param out This is a filename (String) or IO object (typically STDOUT, STDERR, or an open file).
  # @param level Log level
  # @param shift_age Number of old log files to keep, or frequency of rotation (daily, weekly or monthly).
  # @param shift_size Maximum logfile size (only applies when shift_age is a number).
  # @param config The config yaml file to load
  # @param block Format block
  # @return Logger instance
  def logger(out: $stdout, level: 'info', shift_age: 0, shift_size: 1048676, config: nil, &block)
    # Load the config yaml
    if config and File.exists?(config)
      settings = YAML.load_file(config)[ENV['RAILS_ENV']]["logger"]
      settings.each {|key, val| instance_eval("#{key} = val") if defined?(key) } # keyword arguments merge
    end

    if out.kind_of?(String) # String
      out = File.expand_path(out, ENV['RAILS_ROOT']) # support relative path from yohoushi root
    elsif out.respond_to?(:sync) # IO object
      out.sync = true
    end

    # Default log formart
    block ||= proc do |level, time, _, message|
      # "[#{time.strftime("%Y-%m-%d %H:%M:%S")}] [#{level.rjust(5)}] #{message}\n"
      "time:#{time.strftime("%FT%T%z")}\tlevel:#{level}\tmessage:#{message}\n" # LTSV
    end

    Logger.new(out, shift_age, shift_size).tap do |logger|
      logger.formatter = block
      logger.level = eval("Logger::#{level.upcase}")
    end
  end
end
