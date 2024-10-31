#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/smashing_wallpaper_downloader'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: smashing.rb --month MMYYYY --theme THEME'

  opts.on('--month MONTH', 'Specify the month and year (e.g., 042024)') do |month|
    options[:month] = month
  end

  opts.on('--theme THEME', 'Specify the theme (e.g., flowers)') do |theme|
    options[:theme] = theme
  end
end.parse!

if options[:month].nil? || options[:theme].nil?
  puts 'Please provide both --month and --theme parameters'
  exit
end

downloader = SmashingWallpaperDownloader.new(options[:month], options[:theme])
downloader.download
