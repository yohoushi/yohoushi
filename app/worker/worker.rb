require 'serverengine'

module Worker
  def initialize
    reload
  end

  def reload
    @sleep = config[:interval] || 1
    @processor = Processor.new(self)
  end

  def run
    until @stop
      @processor.process
      sleep @sleep
    end
  end

  def stop
    @stop = true
  end
end
