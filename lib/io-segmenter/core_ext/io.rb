class IO
  def each_segment(*args, max_read_size, &block)
    IOSegmenter::Reader.new(self, IOSegmenter::Parser.new(*args), max_read_size).each(&block)
  end
end
