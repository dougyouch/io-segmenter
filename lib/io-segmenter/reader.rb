# frozen_string_literal: true

module IOSegmenter
  class Reader
    include Enumerable

    DEFAULT_READ_SIZE = 8192

    def initialize(io, parser, max_read_size=DEFAULT_READ_SIZE)
      @io = io
      @parser = parser
      @max_read_size = max_read_size
    end

    def each
      until @io.eof?
        @parser.unpack(@io.read(@max_read_size)) do |segment|
          yield segment
        end
      end
    end

    def self.foreach(*args, &block)
      new(*args).each(&block)
    end
  end
end
