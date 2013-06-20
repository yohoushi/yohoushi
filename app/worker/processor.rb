module Worker
  class Processor < ServerEngine::Processor
    include ::Util

    def process
      report_time(logger) do
        graphs = $mfclient.list_graph
        graphs.each do |graph|
          Graph.find_or_create(path: graph['path'])
        end
        complexes = $mfclient.list_complex
        complexes.each do |complex|
          Graph.find_or_create(path: complex['path'], complex: true)
        end
      end
    rescue => e
      logger.error "#{e.class} #{e.message} #{e.backtrace.first}"
    end
  end
end
