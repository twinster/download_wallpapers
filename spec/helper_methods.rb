# frozen_string_literal: true

module HelperMethods
  def mock_html
    <<~HTML
      <div>
        <h2>Sample Wallpaper</h2>
        <p>This is a sample description.</p>
        <ul>
          <li>Image preview</li>
          <li>with calendar
            <a href="https://test.com/cal-640x480.png" title="Wallpaper - 640x480">640x480</a>,
            <a href="https://test.com/cal-800x600.png" title="Wallpaper - 800x600">800x600</a>
          </li>
          <li> without calendar <a href="https://test.com/no-cal-640x480.png" title="Wallpaper - 640x480">640x480</a></li>
        </li>
        </ul>
      </div>
    HTML
  end

  def with_calendar
    {
      type: 'with_calendar',
      resolutions: [
        { resolution: '640x480', url: 'https://test.com/cal-640x480.png' },
        { resolution: '800x600', url: 'https://test.com/cal-800x600.png' }
      ]
    }
  end

  def without_calendar
    {
      type: 'without_calendar',
      resolutions: [{ resolution: '640x480', url: 'https://test.com/no-cal-640x480.png' }]
    }
  end

  def wallpapers
    [
      {
        title: 'test_wallpaper',
        description: 'This is a sample description.',
        wallpaper_data: [without_calendar]
      }
    ]
  end
end
