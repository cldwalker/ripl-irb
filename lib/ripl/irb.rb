module Ripl
  module Irb
    VERSION = '0.1.0'

    def before_loop
      mock_irb
      super
    end

    def mock_irb
      Object.const_set(:IRB, Module.new).extend MockIrb
    end

    module MockIrb
      def const_missing(*args)
        self.const_set(args[0], Module.new.extend(MockIrb))
      end

      def method_missing(*)
      end
    end
  end
end

Ripl::Shell.send :include, Ripl::Irb if defined? Ripl::Shell
