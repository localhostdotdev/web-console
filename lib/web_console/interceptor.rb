module WebConsole
  module Interceptor
    def self.call(request, exception)
      backtrace_cleaner = request.get_header("action_dispatch.backtrace_cleaner")

      error = ActionDispatch::ExceptionWrapper.new(
        backtrace_cleaner,
        exception
      ).exception

      Thread.current[:__web_console_exception] = error

      if error.is_a?(ActionView::Template::Error)
        Thread.current[:__web_console_exception] = error.cause
      end
    end
  end
end
