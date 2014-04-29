#!/usr/bin/env ruby
require 'yaml'
ENV['RAILS_ENV'] ||= 'production'
ENV['RAILS_ROOT'] ||= File.expand_path('../../..', __FILE__)
Bundler.require(:bin)

module ServerEngine
  class CLI < Thor
    class_option :config, :aliases => ["-c"], :type => :string, :default => 'config/serverengine.conf'
    default_command :start

    def initialize(args = [], opts = [], config = {})
      super(args, opts, config)

      if options[:config] && File.exists?(options[:config])
        config = instance_eval(File.read(options[:config]), options[:config])
        @options = config.merge(@options)
      end
      @options["module_name"] ||= 'Worker'
    end

    desc "start", "Start a serverengine"
    option :require,     :aliases => ["-r"], :type => :string
    option :daemonize,   :aliases => ["-d"], :type => :boolean
    option :interval,    :aliases => ["-i"], :type => :numeric
    option :module_name, :aliases => ["-m"], :type => :string
    # serverengine options
    option :log,         :aliases => ["-l"], :type => :string
    option :pid_path,    :aliases => ["-p"], :type => :string
    option :log_stdout,                      :type => :boolean
    option :log_stderr,                      :type => :boolean
    def start
      Bundler.require(:serverengine)
      load_enviroment(options[:require]) # load rails only in start
      opts = @options.symbolize_keys.except(:require, :config, :module_name)

      se = ServerEngine.create(nil, @options["module_name"].constantize, opts)
      se.run
    end

    desc "stop", "Stops a serverengine"
    option :pid_path,    :aliases => ["-p"], :type => :string
    def stop
      pid = File.read(@options["pid_path"]).to_i

      begin
        Process.kill("QUIT", pid)
        puts "Stopped #{pid}"
      rescue Errno::ESRCH
        puts "ServerEngine #{pid} not running"
      end
    end

    desc "graceful_stop", "Gracefully stops a serverengine"
    option :pid_path,    :aliases => ["-p"], :type => :string
    def graceful_stop
      pid = File.read(@options["pid_path"]).to_i

      begin
        Process.kill("TERM", pid)
        puts "Gracefully stopped #{pid}"
      rescue Errno::ESRCH
        puts "ServerEngine #{pid} not running"
      end
    end

    desc "restart", "Restarts a serverengine"
    option :pid_path,    :aliases => ["-p"], :type => :string
    def restart
      pid = File.read(@options["pid_path"]).to_i

      begin
        Process.kill("HUP", pid)
        puts "Restarted #{pid}"
      rescue Errno::ESRCH
        puts "ServerEngine #{pid} not running"
      end
    end

    desc "graceful_restart", "Graceful restarts a serverengine"
    option :pid_path,    :aliases => ["-p"], :type => :string
    def graceful_restart
      pid = File.read(@options["pid_path"]).to_i

      begin
        Process.kill("USR1", pid)
        puts "Gracefully restarted #{pid}"
      rescue Errno::ESRCH
        puts "ServerEngine #{pid} not running"
      end
    end

    protected

      def load_enviroment(file = nil)
        file ||= "."
        if File.directory?(file) && File.exists?(File.expand_path("#{file}/config/environment.rb"))
          require "rails"
          require File.expand_path("#{file}/config/environment.rb")
          if defined?(::Rails) && ::Rails.respond_to?(:application)
            # Rails 3
            ::Rails.application.eager_load!
          elsif defined?(::Rails::Initializer)
            # Rails 2.3
            $rails_rake_task = false
            ::Rails::Initializer.run :load_application_classes
          end
        elsif File.file?(file)
          require File.expand_path(file)
        end
      end

  end
end

ServerEngine::CLI.start(ARGV)
