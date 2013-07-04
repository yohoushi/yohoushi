module Worker
  class Processor
    include ::Util

    def initialize(logger = Rails.logger, config = WorkerSettings)
      @logger = logger
      @config = config
    end

    attr_accessor :logger, :config

    def process
      report_time(logger) do
        graphs    = $mfclient.list_graph.map   {|g| g['path'] }
        complexes = $mfclient.list_complex.map {|g| g['path'] }
        both      = graphs + complexes

        # diff
        plus  = both
        minus = []
        Graph.select('id, path').find_in_batches(batch_size: 1000) do |batches|
          batches = batches.map(&:path)
          plus   -= batches
          minus  += batches - both
        end

        # create
        complex_plus = plus & complexes
        graph_plus   = plus - complex_plus
        complex_plus.each {|path| Graph.find_or_create(path: path, complex: true) }
        graph_plus.each {|path| Graph.find_or_create(path: path, complex: false) }

        # destroy
        minus.each {|path| Graph.find_by(path: path).destroy_ancestors }
      end
    rescue => e
      logger.error "#{e.class} #{e.message} #{e.backtrace.first}"
      raise e # die, but `god` will reboot it
    end
  end
end
