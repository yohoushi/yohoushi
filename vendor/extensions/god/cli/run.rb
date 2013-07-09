require 'god/cli/run'

module God
  module CLI
    class Run
      def run_in_front
        require 'god'

        # ugly workaround to terminate all processes by Ctrl-C
        # https://bugs.ruby-lang.org/issues/7917
        trapped = false
        Signal.trap('INT') do
          if !trapped
            Thread.new do
              God::CLI::Command.new('stop', @options, ['stop', 'yohoushi'])
              God::CLI::Command.new('terminate', @options, ['terminate'])
            end
            trapped = true
          else
            raise 'Interrupted'
          end
        end

        default_run
      end
    end
  end
end
