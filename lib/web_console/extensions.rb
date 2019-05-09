module Kernel
  module_function

  def console(binding = Bindex.current_bindings.second)
    # one console per thread
    raise WebConsole::DoubleRenderError if Thread.current[:__web_console_binding]
    Thread.current[:__web_console_binding] = binding
    nil
  end
end

class Binding
  def console
    Kernel.console(self)
  end
end
