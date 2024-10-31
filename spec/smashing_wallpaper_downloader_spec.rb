# frozen_string_literal: true

require 'smashing_wallpaper_downloader'
require 'fileutils'
require 'helper_methods'

RSpec.describe SmashingWallpaperDownloader do
  include HelperMethods
  let(:downloader) { described_class.new('072024', 'flowers') }
  let(:scraper) { instance_double(WallpaperScraper) }

  before do
    allow(WallpaperScraper).to receive(:new).and_return(scraper)
    allow(downloader).to receive(:download_image).and_return('fake_image_content')
    allow(scraper).to receive(:fetch_wallpapers).and_return(wallpapers)
  end

  describe '#download' do
    it 'downloads wallpapers for the specified theme and date' do
      expect { downloader.download }.to change { Dir.exist?('test_wallpaper_without_calendar') }.from(false).to(true)
    end
  end

  describe '#download_wallpaper_versions' do
    it 'creates directories and writes files correctly' do
      expect(FileUtils).to receive(:mkdir_p).with('test_wallpaper_without_calendar')

      expect(File).to receive(:write).with('test_wallpaper_without_calendar/640x480.png', 'fake_image_content')

      downloader.download
    end
  end
end
