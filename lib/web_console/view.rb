# helpers
module WebConsole
  class View < ActionView::Base
    def only_on_error_page(*args, &block)
      block.call if Thread.current[:__web_console_exception].present?
    end

    def only_on_regular_page(*args, &block)
      block.call if Thread.current[:__web_console_binding].present?
    end

    def render_javascript(template)
      assign(template: template)
      render(template: template, layout: "layouts/javascript")
    end

    def render_inlined_string(template)
      render(template: template, layout: "layouts/inlined_string")
    end

    # silences rendering of interval views
    def render(*)
      if (logger = WebConsole.logger) && logger.respond_to?(:silence)
        WebConsole.logger.silence { super }
      else
        super
      end
    end
  end
end
