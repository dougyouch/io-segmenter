# frozen_string_literal: true

# IO iterator for parsing segments of streams
class IOSegmenter
  include Enumerable

  def initialize(io, starting_char = '{', ending_char = '}', quote_char = '"', escape_char = '\\', max_read_size = 8192)
    raise('starting_char and ending_char can not be the same value') if starting_char == ending_char

    @io = io
    @starting_char = starting_char
    @ending_char = ending_char
    @quote_char = quote_char
    @escape_char = escape_char
    @max_read_size = max_read_size

    terms = [
      @starting_char,
      @ending_char,
      @quote_char,
      @escape_char
    ]
    terms.compact!
    terms.map! { |str| Regexp.escape(str) }

    @search = Regexp.new('(:?' + terms.join('|') + ')')
  end

  def each
    buffer = String.new

    until @io.eof?
      buffer << @io.read(@max_read_size)
      each_segment(buffer) do |segment|
        yield segment
      end
    end
  end

  def self.foreach(*args, &block)
    new(*args).each(&block)
  end

  private

  def each_segment(buffer)
    return unless (start_offset = buffer.index(@starting_char))

    brackets = 1
    offset = start_offset

    opened_quote = false

    while (offset = buffer.index(@search, offset + 1))
      case buffer[offset]
      when @starting_char
        next if opened_quote
        brackets += 1
      when @ending_char
        next if opened_quote
        brackets -= 1
      when @quote_char
        opened_quote = !opened_quote
        next
      when @escape_char
        offset += 1 if opened_quote
        next
      else
        if @starting_char == buffer[offset, @starting_char.size]
          next if opened_quote
          brackets += 1
        elsif @ending_char == buffer[offset, @ending_char.size]
          next if opened_quote
          brackets -= 1
        else
          raise("unhandled offset #{offset}, at #{buffer[offset, 20]}...")
        end
      end

      next unless brackets.zero?

      len = (offset + @ending_char.size) - start_offset
      yield buffer[start_offset, len]
      buffer.slice!(0, offset + @ending_char.size)
      return buffer unless (start_offset = buffer.index(@starting_char))
      offset = start_offset
      brackets = 1
    end
  end
end
