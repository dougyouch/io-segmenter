# frozen_string_literal: true

require 'helper'
require 'json'

describe 'IOSegmenter::CoreExt::IO' do
  context 'json object parsing' do
    let(:io) { File.open('spec/fixtures/test.json') }
    let(:starting_char) { '{' }
    let(:ending_char) { '}' }
    let(:quote_char) { '"' }
    let(:escape_char) { '\\' }
    let(:max_read_size) { 10 }
    let(:expected_indexes) { 20.times.to_a }

    context 'each_segment' do
      it 'collects index values from the file' do
        indexes = []
        io.each_segment(starting_char, ending_char, quote_char, escape_char, max_read_size) { |part| indexes << JSON.parse(part)['index'] }
        expect(indexes).to eq(expected_indexes)
      end
    end
  end
end

