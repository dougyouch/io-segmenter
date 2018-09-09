class File
  def self.each_segment(file, *args, &block)
    handle = open(file, 'rb')
    handle.each_segment(*args, &block)
  ensure
    handle && handle.close
  end
end
