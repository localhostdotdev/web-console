module WebConsole
  class Evaluator
    cattr_reader :cleaner, default: begin
      cleaner = ActiveSupport::BacktraceCleaner.new

      cleaner.add_silencer do |line|
        line.start_with?(File.expand_path("..", __FILE__))
      end

      cleaner
    end

    def initialize(binding = TOPLEVEL_BINDING)
      @binding = binding
    end

    def eval(input)
      "=> #{@binding.eval(input).inspect}\n"
    rescue Exception => exc
      format_exception(exc)
    end

    private

    def format_exception(exc)
      backtrace = cleaner.clean(Array(exc.backtrace) - caller)

      format = "#{exc.class.name}: #{exc}\n".dup
      format << backtrace.map { |trace| "\tfrom #{trace}\n" }.join
      format
    end
  end
end
