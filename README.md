# io-segmenter

Ruby library for interating over segments in IO.  Avoids loading the entire string in to memory.  Instead it iterates over the file in chunks.  Identifying each chunk by it's opening and closing markers.

Gemfile

```ruby
gem 'io-segmenter'

# with core_ext
gem 'io-segmenter', require: ['io-segmenter',
                              'io-segmenter/core_ext/io',
                              'io-segmenter/core_ext/file',
                              'io-segmenter/core_ext/json'
			     ]
```

Example: Find all ids from a JSON file.

```ruby
require 'io-segmenter'
require 'json'

file = File.open('large_json_stream_file.json')
parser = IOSegmenter::Parser.new('{', '}', '"', '\\')
ids = IOSegmenter::Reader.new(file, parser).map do |segment|
  json_object = JSON.parse(segment)
  json_object['id']
end
file.close
```
Example: Find all ids from an XML file.

```ruby
require 'io-segmenter'
require 'nokogiri'

file = File.open('large_file_of_xml_objects.xml)
parser = IOSegmenter::Parser.new('<item>', '</item>', nil, nil)
ids = IOSegmenter.new(file, parser).map do |segment|
  xml = Nokogiri::XML(segment)
  xml.at_xpath('item/id').content.to_i
end
file.close
```

Example: Transform json file

```ruby
require 'io-segmenter'
require 'json'

File.open('transforms.json', 'wb') do |output|
  IOSegmenter::Writer.write(output, '[', ']', ',') do |writer|
    File.open('large_json_stream_file.json') do |input|
      JSON.each_object(input) do |json_object|
        writer.write(transform(json_object).to_json)
      end
    end
  end
end
```

```ruby
IOSegmenter::Parser.new(starting_char, ending_char, quote_char, escape_char)
```

* **starting_char**: string that indicates the beginning of the segment
* **ending_char**: string that indicates the ending of the segment
* **quote_char**: character indicating a quote, when used starting/ending strings are skipped over when inside quotes
* **escape_char**: character indicating to skip the next character

```ruby
IOSegmenter::Reader.new(io, parser, max_read_size)
```

* **io**: read from this IO object
* **parser**: IOSegmenter::Parser used to detect segments
* **max_read_size**: amount of data to read from the IO object

```ruby
IOSegmenter::Writer.write(io, header, footer, separator)
```

* **io**: write to this IO object
* **header**: string to write before adding segements
* **footer**: string to write after adding all segements
* **separator**: string to add after the first write

### Core-Ext

IO#each_segement(starting_char, ending_char, quote_char, escape_char, max_read_size)

```ruby
require 'io-segmenter'
require 'io-segmenter/core-ext/io'

File.open('ids.log', 'wb') do |writter|
  reader = File.open('large_json_stream_file.json')
  reader.each_segment('{', '}', '"', '\\') do |segment|
    json_object = JSON.parse(segment)
    writter.puts json_object['id']
  end
  reader.close
end
```

File.each_segment(file, starting_char, ending_char, quote_char, escape_char, max_read_size)

```ruby
require 'io-segmenter'
require 'io-segmenter/core-ext/file'

File.open('ids.log', 'wb') do |writter|
  File.each_segment('large_json_stream_file.json', '{', '}', '"', '\\') do |segment|
    json_object = JSON.parse(segment)
    writter.puts json_object['id']
  end
end
```

JSON.each_object(io, max_read_size)

Iterate over JSON arrays of objects.

```ruby
require 'io-segmenter'
require 'io-segmenter/core-ext/json'

File.open('ids.log', 'wb') do |writter|
  JSON.each_object('large_json_stream_file.json') do |json_object|
    writter.puts json_object['id']
  end
end
```

JSON.each_string(io, max_read_size)

Iterate over JSON arrays of strings, strips leading and trailing quotes.

```ruby
require 'io-segmenter'
require 'io-segmenter/core-ext/json'

File.open('ids.log', 'wb') do |writter|
  JSON.each_string('large_json_stream_file.json') do |str|
    writter.puts str
  end
end
```

JSON.each_item(io, max_read_size)

Iterate over JSON array of arrays.

```ruby
require 'io-segmenter'
require 'io-segmenter/core-ext/json'

File.open('ids.log', 'wb') do |writter|
  JSON.each_item('large_json_stream_file.json') do |list|
    writter.puts list.first
  end
end
```

### Contributing to packed-model
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

### Copyright

Copyright (c) 2018 Doug Youch. See LICENSE.txt for
further details.

