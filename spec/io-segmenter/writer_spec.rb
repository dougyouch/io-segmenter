require 'helper'

describe IOSegmenter::Writer do
  context 'write' do
    let(:output_buffer) { String.new }
    let(:output) { StringIO.new(output_buffer) }
    let(:input) { File.open('spec/fixtures/test.json') }
    let(:expected_output) do
      [].tap do |list|
        20.times do |i|
          list << {'index' => i * 2}
        end
      end.to_json
    end

    it 'writes a modified json object' do
      IOSegmenter::Writer.write(output, '[', ']', ',') do |writer|
        JSON.each_object(input) do |data|
          writer.write({'index' => data['index'] * 2}.to_json)
        end
      end
      expect(output_buffer).to eq(expected_output)
    end
  end
end
