# frozen_string_literal: true

require 'wallpaper_scraper'
require 'helper_methods'
require 'nokogiri'

RSpec.describe WallpaperScraper do
  include HelperMethods
  let(:date) { Date.new(2024, 7) }
  let(:theme) { 'flowers' }
  let(:nlp_model) { instance_double(ClaudeNLP) }
  let(:scraper) { described_class.new(date, theme, nlp_model) }
  let(:html_content) { '<html></html>' }

  before do
    allow(scraper).to receive(:download_page_content).and_return(html_content)
    allow(nlp_model).to receive(:description_matches_theme?).and_return(true)
  end

  describe '#fetch_wallpapers' do
    it 'builds url correctly' do
      expected_url = 'https://www.smashingmagazine.com/2024/06/desktop-wallpaper-calendars-july-2024/'
      actual_url = scraper.send(:build_url)

      expect(actual_url).to eq(expected_url)
    end

    it 'returns wallpaper details' do
      allow(Nokogiri::HTML).to receive(:parse).and_return(Nokogiri::HTML(html_content))

      wallpapers = scraper.fetch_wallpapers

      expect(wallpapers).to be_an(Array)
      expect(wallpapers).to all(include(:title, :description, :wallpaper_data))
    end
  end

  describe '#extract_wallpaper_data' do
    it 'extracts wallpaper data correctly' do
      header = Nokogiri::HTML(mock_html).css('h2').first

      result = scraper.send(:extract_wallpaper_data, header)
      expect(result).to eq([with_calendar, without_calendar])
    end
  end
end
