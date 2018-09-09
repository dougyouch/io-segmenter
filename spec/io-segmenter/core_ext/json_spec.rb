# frozen_string_literal: true
require 'helper'

describe 'IOSegmenter::CoreExt::JSON' do
  let(:max_read_size) { 10 }
  let(:io) { File.open(file_name) }

  context 'each_object' do
    let(:file_name) { 'spec/fixtures/test.json' }
    let(:expected_indexes) { 20.times.to_a }

    it 'collects index values from the file' do
      indexes = []
      JSON.each_object(io, max_read_size) { |data| indexes << data['index'] }
      expect(indexes).to eq(expected_indexes)
    end
  end

  context 'each_string' do
    let(:file_name) { 'spec/fixtures/strings.json' }
    let(:expected_strings) { ['foo', 'bar', 'with quote \"', 'with escaping \\\\ \\" \\\\', 'bar'] }

    it 'collects index values from the file' do
      strings = []
      JSON.each_string(io) do |str|
        strings << str
      end
      expect(strings).to eq(expected_strings)
    end
  end

  context 'each_list' do
    let(:file_name) { 'spec/fixtures/list.json' }
    let(:expected_list) { [['foo'], ['bar'], ['with ]quote "'], ['with [escaping \\ " \\'], ['[bar]']] }

    it 'collects index values from the file' do
      list = []
      JSON.each_item(io) do |str|
        list << str
      end
      expect(list).to eq(expected_list)
    end
  end
end
