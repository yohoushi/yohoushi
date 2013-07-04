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

  # just alias
  def sql
    ActiveRecord::Base.connection
  end

  # Convert array of strings to `("a", "b")` format to use at IN clause of SQL
  def in_clause(array)
    str = array.inspect # ["a", "b"]
    "(#{str[1, str.size-2]})" # ("a", "b")
  end

  # Process block in batches (like ActiveRecord#find_in_batches)
  def in_batches(array, start: 0, batch_size: 1000, &blk)
    last = array.size - 1
    (start..last).step(batch_size).each do |start|
      yield array[start, batch_size]
    end
  end
end
