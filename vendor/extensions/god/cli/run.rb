require 'god/cli/run'

module God
  module CLI
    class Run
      def run_in_front
        require 'god'

        # ugly workaround to terminate all processes by Ctrl-C
        # https://bugs.ruby-lang.org/issues/7917
        Signal.trap('INT') do
          Thread.new do
            God::CLI::Command.new('stop', @options, ['stop', 'yohoushi'])
            sleep 1
            God::CLI::Command.new('terminate', @options, ['terminate'])
          end
        end

        default_run
      end
    end
  end
end
