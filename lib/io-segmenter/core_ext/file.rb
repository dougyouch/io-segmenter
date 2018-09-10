class File
  def self.each_segment(file, *args, max_read_size, &block)
    handle = open(file, 'rb')
    IOSegmenter::Reader.new(handle, IOSegmenter::Parser.new(*args), max_read_size).each(&block)
  ensure
    handle && handle.close
  end
end
