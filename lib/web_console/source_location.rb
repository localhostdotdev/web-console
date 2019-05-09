class SourceLocation
  def initialize(binding)
    @binding = binding
  end

  def path
    @binding.source_location.first
  end

  def lineno
    @binding.source_location.last
  end
end
