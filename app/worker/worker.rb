require 'serverengine'

module Worker
  def initialize
    reload
  end

  def reload
    @sleep = config[:interval] || 1
    @processor = Processor.new
  end

  def run
    until @stop
      @processor.process
      logger.info "Awesome work!"
      sleep @sleep
    end
  end

  def stop
    @stop = true
  end
end
