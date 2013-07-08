require 'logger'
require 'yaml'

module Yohoushi
  module_function

  def rails_env
    defined?(Rails.env) ? Rails.env : ENV['RAILS_ENV'] || 'development'
  end

  # Create a logger instance
  #
  # @param out This is a filename (String) or IO object (typically STDOUT, STDERR, or an open file).
  # @param level Log level
  # @param shift_age Number of old log files to keep, or frequency of rotation (daily, weekly or monthly).
  # @param shift_size Maximum logfile size (only applies when shift_age is a number).
  # @param config The config yaml file to load
  # @param block Format block
  # @return Logger instance
  def logger(params = { 'out' => $stdout, 'level' => 'info', 'shift_age' => 0, 'shift_size' => 1048676, 'config' => nil }, &block)
    # Load the config yaml
    if params['config'] and File.exists?(params['config'])
      params = YAML.load_file(params['config'])[rails_env]["logger"].merge(params)
    end

    if params['out'].kind_of?(String) # String
      # support relative path from yohoushi root
      params['out'] = File.expand_path(params['out'], "#{__FILE__}/../../../")
    elsif params['out'].respond_to?(:sync) # IO object
      params['out'].sync = true
    end

    # Default log formart
    block ||= proc do |level, time, _, message|
      "[#{time.strftime("%Y-%m-%d %H:%M:%S")}] [#{level.rjust(5)}] #{message}\n"
    end

    # Make an instance of logger
    Logger.new(params['out'], params['shift_age'], params['shift_size']).tap do |logger|
      logger.formatter = block
      logger.level = eval("Logger::#{params['level'].upcase}")
    end
  end
end
