# frozen_string_literal: true

module IOSegmenter
  class Parser
    attr_reader :buffer

    def initialize(starting_char, ending_char, quote_char, escape_char)
      @starting_char = starting_char
      @ending_char = ending_char
      @quote_char = quote_char
      @escape_char = escape_char

      terms = [
        @starting_char,
        @ending_char,
        @quote_char,
        @escape_char
      ]
      terms.compact!
      terms.map! { |str| Regexp.escape(str) }

      @search = Regexp.new('(?:' + terms.join('|') + ')')
      @buffer = String.new
    end

    def unpack(str)
      @buffer << str
      each_segment(@buffer) do |segment|
        yield segment
      end
    end

    def each_segment(buffer)
      return unless (start_offset = buffer.index(@starting_char))

      brackets = 1
      offset = start_offset

      opened_quote = false

      while (offset = buffer.index(@search, offset + 1))
        case buffer[offset]
        when @ending_char
          next if opened_quote
          brackets -= 1
        when @starting_char
          next if opened_quote
          brackets += 1
        when @quote_char
          opened_quote = !opened_quote
          next
        when @escape_char
          offset += @escape_char.size
          next
        else
          if @ending_char == buffer[offset, @ending_char.size]
            next if opened_quote
            brackets -= 1
          elsif @starting_char == buffer[offset, @starting_char.size]
            next if opened_quote
            brackets += 1
          else
            raise("unhandled offset #{offset}, at #{buffer[offset, 20]}...")
          end
        end

        next unless brackets.zero?

        len = (offset + @ending_char.size) - start_offset
        yield buffer[start_offset, len]
        buffer.slice!(0, offset + @ending_char.size)
        return unless (start_offset = buffer.index(@starting_char))
        offset = start_offset
        brackets = 1
      end
    end
  end
end
