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
        graphs = $mfclient.list_graph.map {|g| g['path'] }
        in_batches(graphs, batch_size: 1000) do |batches|
          create_or_destroy(batches)
        end

        complexes = $mfclient.list_complex.map {|g| g['path'] }
        in_batches(complexes, batch_size: 1000) do |batches|
          create_or_destroy(batches, complex: true)
        end
      end
    rescue => e
      logger.error "#{e.class} #{e.message} #{e.backtrace.first}"
      raise e # die, but `god` will reboot it
    end

    def create_or_destroy(paths, complex: false)
      selected = sql.execute("select path from nodes where type = 'Graph' AND path IN #{in_clause(paths)}").to_a.flatten
      added   = paths - selected
      removed = selected - paths
      added.each {|add| Graph.find_or_create(path: add, complex: complex) }
      removed.each {|remove| Graph.find_by(path: remove).destroy_ancestors }
      nil
    end
  end
end
