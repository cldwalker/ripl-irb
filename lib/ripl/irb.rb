require 'ripl'

module IRB
end

module Ripl
  module Irb
    VERSION = '0.2.2'

    def before_loop
      mock_irb
      super
    end

    def mock_irb
      mod = Object.const_set(:IRB, Module.new).extend(MockIrb)
      conf = {}.extend ConvertIrb
      class <<mod; self end.send(:define_method, :conf) { conf }
    end

    module ConvertIrb
      CONFIG_MAP = {
        :PROMPT_MODE => :prompt, :PROMPT => :prompt, :HISTORY_FILE => :history,
        :USE_READLINE => :readline, :AP_NAME => :name, :RC => :irbrc
      }

      DESC_MAP = {
        :SINGLE_IRB => "jump commands in ripl-commands plugin have this enabled by default",
        :IRB_RC => "Use ripl-after_rc plugin instead of IRB.conf[:IRB_RC]",
        :AUTO_INDENT => 'Use ripl-auto_indent plugin instead of IRB.conf[:AUTO_INDENT]',
        :SCRIPT => 'Use ripl-play plugin instead of IRB.conf[:SCRIPT]',
        :RC_NAME_GENERATOR => "Use Ripl.config[:history] or Ripl.config[:irbrc] "+
          "instead of IRB.conf[:RC_NAME_GENERATOR]",
        :MAIN_CONTEXT => 'Use Ripl.shell instead of IRB.conf[:MAIN_CONTEXT]',
        :LOAD_MODULES => 'No need to use IRB.conf[:LOAD_MODULES]. Just use require :)',
        :SAVE_HISTORY => 'See https://github.com/cldwalker/ripl-misc/blob/master/lib/ripl/history_size.rb for IRB.conf[:SAVE_HISTORY]',
        :MATH_MODE => 'See https://github.com/cldwalker/ripl-misc/blob/master/lib/ripl/math.rb for IRB.conf[:MATH_MODE]',
        :ECHO => 'See https://github.com/cldwalker/ripl-misc/blob/master/lib/ripl/echo.rb for IRB.conf[:ECHO]',
        :INSPECT_MODE => 'See https://github.com/cldwalker/ripl-misc/blob/master/lib/ripl/inspect.rb for IRB.conf[:INSPECT_MODE]',
        :BACK_TRACE_LIMIT => 'See https://github.com/cldwalker/ripl-misc/blob/master/lib/ripl/backtrace_limit.rb for IRB.conf[:BACK_TRACE_LIMIT]',
        :IGNORE_SIGINT => 'See https://github.com/cldwalker/ripl-misc/blob/master/lib/ripl/ignore_sigint.rb for IRB.conf[:IGNORE_SIGINT]'
      }

      RETURN_MAP = {
        :LOAD_MODULES => [], :IRB_RC => lambda { }, :RC_NAME_GENERATOR => lambda { },
        :SAVE_HISTORY => 500, :PROMPT => {}, :HISTORY_FILE => ''
      }

      def []=(key, val)
        self[key]
        val
      end

      def [](key)
        return RETURN_MAP[key] unless Ripl.config[:irb_verbose]
        if ripl_key = CONFIG_MAP[key]
          puts "Use Ripl.config[#{ripl_key.inspect}] instead of IRB.conf[#{key.inspect}]"
        elsif desc = DESC_MAP[key]
          puts desc
        end
        RETURN_MAP[key]
      end
    end

    module MockIrb
      def const_missing(*args)
        self.const_set(args[0], Module.new.extend(MockIrb))
      end

      def method_missing(*)
      end
    end

    module Commands
      JUMP_COMMANDS = [:bindings, :cb, :chws, :cws, :cwws, :fg, :irb, :irb_bindings, :irb_cb,
        :irb_change_binding, :irb_change_workspace, :irb_chws, :irb_current_working_binding,
        :irb_current_working_workspace, :irb_cwb, :irb_cws, :irb_cwws, :irb_exit, :irb_fg,
        :irb_jobs, :irb_kill, :irb_pop_binding, :irb_pop_workspace, :irb_popb, :irb_popws,
        :irb_print_working_binding, :irb_print_working_workspace, :irb_push_binding,
        :irb_push_workspace, :irb_pushb, :irb_pushws, :irb_pwb, :irb_pwws, :irb_workspaces, :jobs,
        :kill, :popb, :popws, :pushb, :pushws, :pwws, :workspaces]

      (JUMP_COMMANDS - Ripl::Commands.instance_methods.map {|e| e.to_sym }).each do |meth|
        define_method(meth) do
          puts "See jump() and jumps() in ripl-commands plugin" if Ripl.config[:irb_verbose]
        end
      end

      [:conf, :irb_context, :context].each do |meth|
        define_method(meth) do
          puts "See config() in ripl-commands plugin" if Ripl.config[:irb_verbose]
        end
      end
    end
  end
end

Ripl::Shell.send :include, Ripl::Irb
Ripl::Commands.send :include, Ripl::Irb::Commands
Ripl.config[:irb_verbose] = true
