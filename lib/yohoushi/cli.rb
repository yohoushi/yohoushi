#!/usr/bin/env ruby
# This is a copy and customized version of bin/god

STDOUT.sync = true

$:.unshift File.join(File.dirname(__FILE__), *%w[.. .. lib])

require 'optparse'
require 'drb'
require 'yaml'
RAILS_ENV ||= ENV['RAILS_ENV'] ||= 'development'
RAILS_ROOT ||= ENV['RAILS_ROOT'] ||= File.expand_path('../../..', __FILE__)

begin
  # Save ARGV in case someone wants to use it later
  ORIGINAL_ARGV = ARGV.dup

  options = {:daemonize => true, :port => 17165, :syslog => true, :events => true}
  options[:daemonize] = false # yohoushi custom
  options[:config]    = "#{RAILS_ROOT}/config/yohoushi.god" # yohoushi custom

  opts = OptionParser.new do |opts|
    opts.banner = <<-EOF
  Usage:
    Starting:
      yohoushi [-c <config file>] [-p <port> | -b] [-P <file>] [-l <file>] [-D]

    Querying:
      yohoushi <command> <argument> [-p <port>]
      yohoushi <command> [-p <port>]
      yohoushi -v
      yohoushi -V (must be run as root to be accurate on Linux)

    Commands:
      start <task or group name>         start task or group
      restart <task or group name>       restart task or group
      stop <task or group name>          stop task or group
      monitor <task or group name>       monitor task or group
      unmonitor <task or group name>     unmonitor task or group
      remove <task or group name>        remove task or group from yohoushi
      load <file> [action]               load a config into a running yohoushi
      log <task name>                    show realtime log for given task
      status [task or group name]        show status
      signal <task or group name> <sig>  signal all matching tasks
      quit                               stop yohoushi
      stop | terminate                   stop yohoushi and all tasks
      check                              run self diagnostic

    Options:
  EOF

    opts.on("-cCONFIG", "--config-file CONFIG", "Configuration file") do |x|
      options[:config] = x
    end

    opts.on("-pPORT", "--port PORT", "Communications port (default 17165)") do |x|
      options[:port] = x
    end

    opts.on("-b", "--auto-bind", "Auto-bind to an unused port number") do
      options[:port] = "0"
    end

    opts.on("-PFILE", "--pid FILE", "Where to write the PID file") do |x|
      options[:pid] = x
    end

    opts.on("-lFILE", "--log FILE", "Where to write the log file") do |x|
      options[:log] = x
    end

    opts.on("-D", "--no-daemonize", "Don't daemonize") do
      options[:daemonize] = false
    end

    # yohoushi custom
    opts.on("-d", "--daemonize", "Daemonize") do
      options[:daemonize] = true
    end

    opts.on("-v", "--version", "Print the version number and exit") do
      options[:version] = true
    end

    opts.on("-V", "Print the version and build information of god") do
      options[:info] = true
    end

    opts.on("--log-level LEVEL", "Log level [debug|info|warn|error|fatal]") do |x|
      options[:log_level] = x.to_sym
    end

    opts.on("--no-syslog", "Disable output to syslog") do
      options[:syslog] = false
    end

    opts.on("--attach PID", "Quit god when the attached process dies") do |x|
      options[:attach] = x
    end

    opts.on("--no-events", "Disable the event system") do
      options[:events] = false
    end

    opts.on("--bleakhouse", "Enable bleakhouse profiling") do
      options[:bleakhouse] = true
    end
  end

  opts.parse!

  # validate
  if options[:log_level] && ![:debug, :info, :warn, :error, :fatal].include?(options[:log_level])
    abort("Invalid log level '#{options[:log_level]}'")
  end

  # Use this flag to actually load all of the god infrastructure
  $load_god = true

  # dispatch
  if options[:version]
    require 'yohoushi/version' # yohoushi custom
    puts "Version: #{Yohoushi::VERSION}" # yohoushi custom
  elsif options[:info]
    require 'god'
    God::EventHandler.load
    God::CLI::Version.version_extended
  elsif command = ARGV[0]
    require 'god'
    God::EventHandler.load
    if command == 'restart' and !ARGV[1] # yohoushi custom
      God::CLI::Command.new(command, options, [command, "yohoushi"])
    elsif command == 'stop' and !ARGV[1] # yohoushi custom
      God::CLI::Command.new('stop', options, ['stop', 'yohoushi'])
      sleep 1
      God::CLI::Command.new('terminate', options, ARGV)
    else
      God::CLI::Command.new(command, options, ARGV)
    end
  else
    puts "Sending output to log file: #{RAILS_ROOT}/log/yohoushi.log"
    require 'god/cli/run'
    require File.expand_path('../../../vendor/extensions/god/cli/run', __FILE__) # yohoushi custom
    God::CLI::Run.new(options)
  end
rescue Exception => e
  if e.instance_of?(SystemExit)
    raise
  else
    puts 'Uncaught exception'
    puts e.message
    puts e.backtrace.join("\n")
  end
end
