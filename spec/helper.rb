# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'json'
require 'simplecov'

SimpleCov.start

begin
  Bundler.setup(:default, :development, :spec)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'io-segmenter'
require 'io-segmenter/core_ext/io'
require 'io-segmenter/core_ext/file'
require 'io-segmenter/core_ext/json'
