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
        # create and mark
        graphs = $mfclient.list_graph
        graphs.each do |graph|
          Graph.find_or_create(path: graph['path'], mark: true)
        end
        complexes = $mfclient.list_complex
        complexes.each do |complex|
          Graph.find_or_create(path: complex['path'], complex: true, mark: true)
        end
        # delete non-marked nodes
        Node.destroy_all(:mark => nil)
        # restore mark for next mark and sweep
        Node.unmark_all
      end
    rescue => e
      logger.error "#{e.class} #{e.message} #{e.backtrace.first}"
    end
  end
end
