module Worker
  class Processor < ServerEngine::Processor
    def process
      logger.info "Awesome work!"
    end
  end
end
