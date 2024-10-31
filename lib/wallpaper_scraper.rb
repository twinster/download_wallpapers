# frozen_string_literal: true

require 'nokogiri'
require 'net/http'
require 'open-uri'
require_relative 'claude_nlp'

# This class is responsible for scrapping necessary wallpaper images from a specified webpage
class WallpaperScraper
  BASE_URL = 'https://www.smashingmagazine.com'

  def initialize(date, theme, nlp_model)
    @date = date
    @theme = theme.downcase
    @nlp_model = nlp_model
  end

  def fetch_wallpapers
    doc = Nokogiri::HTML(download_page_content(build_url))

    doc.css('h2').map { |header| fetch_wallpaper_details header }.compact
  end

  private

  def download_page_content(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    response.body if response.is_a?(Net::HTTPSuccess)
  end

  def build_url
    "#{BASE_URL}/#{year}/#{month_num}/desktop-wallpaper-calendars-#{month_year}/"
  end

  def year
    @date.strftime('%Y')
  end

  def month_num
    @date.prev_month.strftime('%m')
  end

  def month_year
    @date.strftime('%B-%Y').downcase
  end

  def fetch_wallpaper_details(header)
    description = header.xpath('following-sibling::p[1]').text.strip
    return unless @nlp_model.description_matches_theme?(description, @theme)

    title = header.text.strip.downcase
    wallpaper_data = extract_wallpaper_data(header)

    {
      title: title,
      description: description,
      wallpaper_data: wallpaper_data
    }
  end

  def extract_wallpaper_data(header)
    list_items = header.xpath('following-sibling::ul[1]/li')
    wallpapers = []
    list_items.each do |li|
      option = li.text.downcase
      next if option.include?('preview')

      type = option.include?('with calendar') ? 'with_calendar' : 'without_calendar'
      resolutions = li.css('a').map { |a| { resolution: a.text.strip, url: a['href'] } }

      wallpapers << { type: type, resolutions: resolutions }
    end

    wallpapers
  end
end
