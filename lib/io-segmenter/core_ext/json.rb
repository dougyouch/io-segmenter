# frozen_string_literal: true

module JSON
  def self.each_object(io, max_read_size=IOSegmenter::DEFAULT_READ_SIZE, &block)
    IOSegmenter.new(io, '{', '}', '"', '\\', max_read_size).each do |segement|
      yield parse(segement)
    end
  end

  def self.each_string(io, max_read_size=IOSegmenter::DEFAULT_READ_SIZE)
    IOSegmenter.new(io, '"', '"', nil, '\\', max_read_size).each do |segement|
      yield segement[1, segement.size-2]
    end
  end

  def self.each_item(io, max_read_size=IOSegmenter::DEFAULT_READ_SIZE)
    io.read(1)
    IOSegmenter.new(io, '[', ']', '"', '\\', max_read_size).each do |segement|
      yield parse(segement)
    end
  end
end
