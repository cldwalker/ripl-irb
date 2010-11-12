module Ripl
  module Irb
    VERSION = '0.1.2'

    def before_loop
      mock_irb
      super
    end

    def mock_irb
      mod = Object.const_set(:IRB, Module.new).extend(MockIrb)
      class <<mod; self end.send(:define_method, :conf) { {} }
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
