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
        marks = Graph.start_marking
        # create and mark
        graphs = $mfclient.list_graph
        graphs.each do |graph|
          Graph.find_or_create(path: graph['path'])
        end
        complexes = $mfclient.list_complex
        complexes.each do |complex|
          Graph.find_or_create(path: complex['path'], complex: true)
        end
        # sweep non-marked nodes
        Node.where.not(:id => marks.uniq).destroy_all
        Graph.stop_marking
      end
    rescue => e
      logger.error "#{e.class} #{e.message} #{e.backtrace.first}"
    end
  end
end
