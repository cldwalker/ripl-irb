require 'ripl'

module Ripl
  module Irb
    VERSION = '0.1.2'

    def before_loop
      mock_irb
      super
    end

    CONFIG_MAP = {
      :PROMPT_MODE => :prompt, :PROMPT => :prompt, :HISTORY_FILE => :history,
      :USE_READLINE => :readline, :AP_NAME => :name, :RC => :irbrc
    }
    DESC_MAP = {
      :SINGLE_IRB => "jump commands in ripl-commands plugin have this enabled by default",
      :IRB_RC => "Use ripl-after_rc plugin instead of IRB.conf[:IRB_RC]",
      :RC_NAME_GENERATOR => "Use Ripl.config[:history] or Ripl.config[:irbrc] "+
        "instead of IRB.conf[:RC_NAME_GENERATOR]",
      :LOAD_MODULES => 'No need for irb or ripl to do this. Just use require :)'
    }

    def mock_irb
      mod = Object.const_set(:IRB, Module.new).extend(MockIrb)
      conf = {}
      def conf.[]=(key, val)
        return unless Ripl.config[:irb_verbose]
        if ripl_key = CONFIG_MAP[key]
          puts "Use Ripl.config[#{ripl_key.inspect}] instead of IRB.conf[#{key.inspect}]"
        elsif desc = DESC_MAP[key]
          puts desc
        end
      end
      class <<mod; self end.send(:define_method, :conf) { conf }
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

Ripl::Shell.send :include, Ripl::Irb
Ripl.config[:irb_verbose] = true
