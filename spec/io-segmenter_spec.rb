# frozen_string_literal: true

require 'helper'
require 'json'

describe IOSegmenter do
  context 'json object parsing' do
    let(:io) { File.open('spec/fixtures/test.json') }
    let(:starting_char) { '{' }
    let(:ending_char) { '}' }
    let(:quote_char) { '"' }
    let(:escape_char) { '\\' }
    let(:max_read_size) { 10 }
    let(:splitter) { IOSegmenter.new(io, starting_char, ending_char, quote_char, escape_char, max_read_size) }
    let(:expected_indexes) { 20.times.to_a }

    it 'starting and ending elements are returned' do
      part = splitter.first
      expect(part[0, starting_char.size] == starting_char).to eq(true)
      expect(part[part.size - ending_char.size, ending_char.size] == ending_char).to eq(true)
    end

    context 'each' do
      it 'collects index values from the file' do
        expect(splitter.map { |part| JSON.parse(part)['index'] }).to eq(expected_indexes)
      end
    end

    context 'foreach' do
      it 'collects index values from the file' do
        indexes = []
        IOSegmenter.foreach(io, starting_char, ending_char, quote_char, escape_char, max_read_size) do |part|
          indexes << JSON.parse(part)['index']
        end
        expect(indexes).to eq(expected_indexes)
      end
    end
  end

  context 'json string parsing' do
    let(:io) { File.open('spec/fixtures/strings.json') }
    let(:starting_char) { '"' }
    let(:ending_char) { '"' }
    let(:quote_char) { nil }
    let(:escape_char) { '\\' }
    let(:max_read_size) { 10 }
    let(:splitter) { IOSegmenter.new(io, starting_char, ending_char, quote_char, escape_char, max_read_size) }
    let(:expected_strings) { ['foo', 'bar', 'with quote \\"', 'with escaping \\\\ \\" \\\\', 'bar'] }

    context 'each' do
      it 'collects index values from the file' do
        strings = []
        splitter.each do |str|
          strings << str.slice(1, str.size-2)
        end
        expect(strings).to eq(expected_strings)
      end
    end
  end

  context 'xml parsing' do
    let(:io) { File.open('spec/fixtures/test.xml') }
    let(:starting_char) { '<item>' }
    let(:ending_char) { '</item>' }
    let(:quote_char) { nil }
    let(:escape_char) { nil }
    let(:max_read_size) { 10 }
    let(:splitter) { IOSegmenter.new(io, starting_char, ending_char, quote_char, escape_char, max_read_size) }
    let(:expected_indexes) { 20.times.to_a }

    it 'starting and ending elements are returned' do
      part = splitter.first
      expect(part[0, starting_char.size] == starting_char).to eq(true)
      expect(part[part.size - ending_char.size, ending_char.size] == ending_char).to eq(true)
    end

    context 'each' do
      it 'collects index values from the file' do
        expect(splitter.map { |part| part =~ /<index type="integer">(\d+)<\/index>/; $1.to_i }).to eq(expected_indexes)
      end
    end

    context 'foreach' do
      it 'collects index values from the file' do
        indexes = []
        IOSegmenter.foreach(io, starting_char, ending_char, quote_char, escape_char, max_read_size) do |part|
          part =~ /<index type="integer">(\d+)<\/index>/
          indexes << $1.to_i
        end
        expect(indexes).to eq(expected_indexes)
      end
    end
  end
end
