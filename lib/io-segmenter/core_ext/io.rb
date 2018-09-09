class IO
  def each_segment(*args, &block)
    IOSegmenter.new(self, *args).each(&block)
  end
end
