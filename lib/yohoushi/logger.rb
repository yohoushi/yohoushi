require 'logger'
require 'yaml'
RAILS_ENV  ||= ENV['RAILS_ENV']  ||= 'development'
RAILS_ROOT ||= ENV['RAILS_ROOT'] ||= File.expand_path('../../..', __FILE__)

module Yohoushi
  module_function

  def log_level
    RAILS_ENV == 'development' ? 'debug' : 'info'
  end

  # Create a logger instance
  #
  # @param out This is a filename (String) or IO object (typically STDOUT, STDERR, or an open file).
  # @param level Log level
  # @param shift_age Number of old log files to keep, or frequency of rotation (daily, weekly or monthly).
  # @param shift_size Maximum logfile size (only applies when shift_age is a number).
  # @param config The config yaml file to load
  # @param service The service name to print in the log
  # @param block Format block
  # @return Logger instance
  def logger(out: $stdout, level: log_level, shift_age: 0, shift_size: 10485760, config: nil, service: nil, &block)
    # Load the config yaml
    if config and File.exists?(config)
      settings = YAML.load_file(config)[RAILS_ENV]["logger"]
      settings.each {|key, val| instance_eval("#{key} = val") if defined?(key) } # keyword arguments merge
    end

    if out.kind_of?(String) # String
      out = File.expand_path(out, RAILS_ROOT) # support relative path from yohoushi root
    elsif out.respond_to?(:sync) # IO object
      out.sync = true
    end

    # Default log formart (LTSV)
    if service
      block ||= proc do |level, time, _, message|
        "time:#{time.strftime("%FT%T%z")}\tlevel:#{level}\tservice:#{service}\tmessage:#{message}\n"
      end
    else
      block ||= proc do |level, time, _, message|
        "time:#{time.strftime("%FT%T%z")}\tlevel:#{level}\tmessage:#{message}\n"
      end
    end

    Logger.new(out, shift_age, shift_size).tap do |logger|
      logger.formatter = block
      logger.level = eval("Logger::#{level.upcase}")
    end
  end
end
