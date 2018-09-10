# frozen_string_literal: true

module JSON
  def self.each_object(io, max_read_size=nil, &block)
    IOSegmenter::Reader.new(io, IOSegmenter::Parser.new('{', '}', '"', '\\'), max_read_size || IOSegmenter::Reader::DEFAULT_READ_SIZE).each do |segement|
      yield parse(segement)
    end
  end

  def self.each_string(io, max_read_size=nil)
    IOSegmenter::Reader.new(io, IOSegmenter::Parser.new('"', '"', nil, '\\'), max_read_size || IOSegmenter::Reader::DEFAULT_READ_SIZE).each do |segement|
      yield segement[1, segement.size-2]
    end
  end

  def self.each_list(io, max_read_size=nil)
    io.read(1)
    IOSegmenter::Reader.new(io, IOSegmenter::Parser.new('[', ']', '"', '\\'), max_read_size || IOSegmenter::Reader::DEFAULT_READ_SIZE).each do |segement|
      yield parse(segement)
    end
  end
end
