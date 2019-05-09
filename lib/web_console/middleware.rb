require "active_support/core_ext/string/strip"

# headers
#
#   X-Web-Console-Session-Id
#   X-Web-Console-Mount-Point
#
# endpoints
#
#   PUT /__web_console/repl_sessions/:id
#   POST /__web_console/repl_sessions/:id/trace
#
module WebConsole
  class Middleware
    TEMPLATES_PATH = File.expand_path("../templates", __FILE__)

    cattr_accessor :mount_point, default: "/__web_console"

    def initialize(app)
      @app = app
    end

    def call(env)
      app_exception = catch :app_exception do
        request = Request.new(env)
        return call_app(env) unless request.permitted? # ips whilelisted

        if id = id_for_repl_session_update(request)
          return update_repl_session(id, request)
        elsif id = id_for_repl_session_stack_frame_change(request)
          return change_stack_trace(id, request)
        end

        status, headers, body = call_app(env)

        session = Session.current

        if session && acceptable_content_type?(headers)
          headers["X-Web-Console-Session-Id"] = session.id
          headers["X-Web-Console-Mount-Point"] = mount_point

          template = Template.new(env, session)
          body, headers = Injector.new(body, headers).inject(template.render("index"))
        end

        [status, headers, body]
      end
    rescue => e
      WebConsole.logger.error(
        "\n#{e.class}: #{e}\n\tfrom #{e.backtrace.join("\n\tfrom ")}"
      )
      raise e
    ensure
      Thread.current[:__web_console_exception] = nil
      Thread.current[:__web_console_binding] = nil

      raise app_exception if Exception === app_exception
    end

    private

    def acceptable_content_type?(headers)
      headers["Content-Type"].to_s.include?("html")
    end

    def json_response(opts = {}, &block)
      status = opts.fetch(:status, 200)
      headers = { "Content-Type" => "application/json; charset = utf-8" }
      body = block.call.to_json

      [status, headers, [body]]
    end

    def json_response_with_session(id, request, opts = {}, &block)
      return respond_with_unavailable_session(id) unless session = Session.find(id)

      json_response(opts) { block.call(session) }
    end

    def repl_sessions_re
      @_repl_sessions_re ||= %r{#{mount_point}/repl_sessions/(?<id>[^/]+)}
    end

    def update_re
      @_update_re ||= %r{#{repl_sessions_re}\z}
    end

    def binding_change_re
      @_binding_change_re ||= %r{#{repl_sessions_re}/trace\z}
    end

    def id_for_repl_session_update(request)
      if request.xhr? && request.put?
        update_re.match(request.path) { |m| m[:id] }
      end
    end

    def id_for_repl_session_stack_frame_change(request)
      if request.xhr? && request.post?
        binding_change_re.match(request.path) { |m| m[:id] }
      end
    end

    def update_repl_session(id, request)
      json_response_with_session(id, request) do |session|
        if input = request.params[:input]
          { output: session.eval(input) }
        elsif input = request.params[:context]
          { context: session.context(input) }
        end
      end
    end

    def change_stack_trace(id, request)
      json_response_with_session(id, request) do |session|
        session.switch_binding_to(
          request.params[:frame_id],
          request.params[:exception_object_id]
        )

        { ok: true }
      end
    end

    def respond_with_unavailable_session(id)
      json_response(status: 404) do
        { output: format(I18n.t("errors.unavailable_session"), id: id) }
      end
    end

    def respond_with_unacceptable_request
      json_response(status: 406) do
        { output: I18n.t("errors.unacceptable_request") }
      end
    end

    def call_app(env)
      @app.call(env)
    rescue => e
      throw :app_exception, e
    end
  end
end
