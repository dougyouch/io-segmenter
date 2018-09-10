# frozen_string_literal: true

module IOSegmenter
  # Used to add a separator after the first write call
  class Writer
    def self.write(io, header, footer, separator)
      io.write(header) if header
      yield new(io, separator)
      io.write(footer) if footer
    end

    def initialize(io, separator)
      @io = io
      @separator = separator
      @add_separator = false
    end

    def write(str)
      @io.write(@separator) if @separator && @add_separator
      @io.write(str)
      @add_separator = true
    end
  end
end
