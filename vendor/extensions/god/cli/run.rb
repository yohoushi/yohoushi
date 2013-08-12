require 'god/cli/run'

module God
  module CLI
    class Run
      def default_run_with_trap
        # ugly workaround to terminate all processes by Ctrl-C and kill -TERM
        # https://bugs.ruby-lang.org/issues/7917
        @trapped = false
        Signal.trap('INT') { try_stop }
        Signal.trap('TERM') { try_stop }

        default_run_without_trap
      end
      alias_method :default_run_without_trap, :default_run
      alias_method :default_run, :default_run_with_trap

      def try_stop
        if !@trapped
          Thread.new do
            God::CLI::Command.new('stop', @options, ['stop', 'yohoushi'])
            God::CLI::Command.new('terminate', @options, ['terminate'])
          end
          @trapped = true
        else
          raise 'Interrupted'
        end
      end

    end
  end
end
