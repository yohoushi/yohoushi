module Util
  def self.included(base)
    base.extend Util
  end

  def report_time(logger = Rails.logger, &blk)
    t = Time.now
    output = yield
    logger.debug "Elapsed time: %.2f seconds at %s" % [(Time.now - t).to_f, caller()[0]]
    output
  end

  def try_kill(signal = 'QUIT', pid_file)
    begin
      pid = File.read(pid_file).to_i
      Process.kill(signal, pid)
    rescue => e
      $stderr.puts "kill -#{signal} `cat #{pid_file}`"
      $stderr.puts "#{e.class} #{e.message}"
    end
  end
end
