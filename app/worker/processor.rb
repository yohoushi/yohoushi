module Worker
  class Processor
    include ::Util

    def initialize(logger = Rails.logger, config = {})
      @logger = logger
      @config = config
    end

    attr_accessor :logger, :config

    def process
      report_time(logger) do
        graphs      = $mfclient.list_graph.map   {|g| g['path'] }
        complexes   = $mfclient.list_complex.map {|g| g['path'] }
        plus, minus = Graph.find_diff(graphs + complexes)

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
