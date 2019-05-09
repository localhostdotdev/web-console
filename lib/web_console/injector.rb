module WebConsole
  class Injector
    def initialize(body, headers)
      @body = ""

      body.each { |part| @body << part }
      body.close if body.respond_to?(:close)

      @headers = headers
    end

    def inject(content)
      @headers.delete("Content-Length") # because some content is added

      [
        if position = @body.rindex("</body>")
          [ @body.insert(position, content) ]
        else
          [ @body << content ]
        end,
        @headers
      ]
    end
  end
end
