class File
  def self.each_segment(file, *args, &block)
    handle = open(file, 'rb')
    IOSegmenter.new(handle, *args).each(&block)
  ensure
    handle && handle.close
  end
end
