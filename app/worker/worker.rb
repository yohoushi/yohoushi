require 'serverengine'

module Worker
  def run
    until @stop
      logger.info "Awesome work!"
      sleep 1
    end
  end

  def stop
    @stop = true
  end
end
