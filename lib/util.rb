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
end
