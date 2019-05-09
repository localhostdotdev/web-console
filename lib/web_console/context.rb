module WebConsole
  class Context
    def initialize(binding)
      @binding = binding
    end

    def extract(input = nil)
      input.present? ? local(input) : global
    end

    private

    GLOBAL_OBJECTS = [
      "instance_variables",
      "local_variables",
      "methods",
      "class_variables",
      "Object.constants",
      "global_variables"
    ]

    def global
      GLOBAL_OBJECTS.map { |cmd| eval(cmd) }
    end

    def local(input)
      [
        eval("#{input}.methods").map { |m| "#{input}.#{m}" },
        eval("#{input}.constants").map { |c| "#{input}::#{c}" },
      ]
    end

    def eval(cmd)
      @binding.eval(cmd) rescue []
    end
  end
end
