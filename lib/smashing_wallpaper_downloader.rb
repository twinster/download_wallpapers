# frozen_string_literal: true

require_relative 'wallpaper_scraper'
require 'date'
require 'net/http'
require 'open-uri'

# This class is responsible for automating the process of downloading desktop wallpapers.
# it fetches wallpapers based on specified themes, month, and year, and downloads them in all available resolutions.
class SmashingWallpaperDownloader
  def initialize(date_str, theme)
    date = Date.strptime(date_str, '%m%Y')
    theme = theme.downcase
    claude_nlp = ClaudeNLP.new
    @scraper = WallpaperScraper.new(date, theme, claude_nlp)
  end

  def download
    wallpapers = @scraper.fetch_wallpapers
    wallpapers.each do |wallpaper|
      wallpaper[:wallpaper_data].each do |data|
        download_wallpaper_versions(wallpaper[:title], data[:type], data[:resolutions])
      end
    end
  end

  private

  def download_wallpaper_versions(title, version_type, resolutions)
    version_folder = "#{title}_#{version_type}"
    FileUtils.mkdir_p(version_folder)

    resolutions.each do |resolution|
      image_path = "#{version_folder}/#{resolution[:resolution]}.png"
      File.write(image_path, download_image(resolution[:url]))
      puts "Downloaded #{resolution[:resolution]} for #{title} (#{version_type})"
    end
  end

  def download_image(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    response.body if response.is_a?(Net::HTTPSuccess)
  end
end
