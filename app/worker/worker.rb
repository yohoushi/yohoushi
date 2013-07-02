require 'serverengine'

module Worker
  def initialize
    reload
  end

  def reload
    @sleep = config[:interval] || 1
    @processor = Processor.new(logger, config)
  end

  def run
    logger.info "Yohoushi worker started."
    until @stop
      @processor.process
      sleep @sleep
    end
    logger.info "Yohoushi worker stopped."
  end

  def stop
    @stop = true
  end
end
