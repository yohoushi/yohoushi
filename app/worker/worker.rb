require 'serverengine'

module Worker
  include ::Util

  def initialize
    reload
  end

  def reload
    @sleep = config[:interval] || 1
    @processor = Processor.new(logger, config)
  end

  def run
    @stop = false
    logger.info "Yohoushi worker started."
    until @stop
      wait(@sleep) { @processor.process }
    end
    logger.info "Yohoushi worker stopped."
  end

  def stop
    @stop = true
  end
end
