module WebConsole
  class Session
    cattr_reader :inmemory_storage, default: {}

    attr_reader :id

    def initialize(exception_mappers)
      @id = SecureRandom.hex(16)
      @exception_mappers = exception_mappers
      @evaluator = Evaluator.new(@current_binding = exception_mappers.first.first)

      store_into_memory
    end

    def self.find(id)
      inmemory_storage[id]
    end

    def self.current
      if exc = Thread.current[:__web_console_exception]
        new(ExceptionMapper.follow(exc))
      elsif binding = Thread.current[:__web_console_binding]
        new([[binding]])
      end
    end

    def eval(input)
      @evaluator.eval(input)
    end

    def switch_binding_to(index, exception_object_id)
      bindings = ExceptionMapper.find_binding(@exception_mappers, exception_object_id)
      @evaluator = Evaluator.new(@current_binding = bindings[index.to_i])
    end

    def context(objpath)
      Context.new(@current_binding).extract(objpath)
    end

    private

    def store_into_memory
      inmemory_storage[id] = self
    end
  end
end
