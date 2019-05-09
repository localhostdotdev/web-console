module WebConsole
  class Template
    cattr_accessor :template_paths, default: [
      File.expand_path("../templates", __FILE__)
    ]

    def initialize(env, session)
      @env = env
      @session = session
      @mount_point = Middleware.mount_point
    end

    def render(template)
      view = View.new(ActionView::LookupContext.new(template_paths), instance_values)
      view.render(template: template, layout: false)
    end
  end
end
