class Driver
  NAME = :selenium_chrome

  # Configures Capybara to use PhantomJS/Poltergeist.
  def self.configure
    Capybara.run_server = false
    register
    Capybara.current_driver = NAME
    Capybara.configure do |config|
      #config.javascript_driver = :poltergeist
      #config.ignore_hidden_elements = true
      config.default_max_wait_time = 30
    end
  end

  def self.register
    Capybara.register_driver :selenium_chrome do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--window-size=1024x768')
      Capybara::Selenium::Driver.new(app, browser: :chrome,
                                      options: options)
    end
    # Capybara.register_driver(NAME) do |app|
    #   c = Capybara::Poltergeist::Driver.new(app, options)
    #   c.headers = { 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36' }
    #   c
    # end
  end

  def self.options
    {
      :phantomjs => Phantomjs.path,
      # Do not raise Ruby exceptions when JavaScript errors occur.
      :js_errors => false,
      # Suppress "ran insecure content" warnings from PhantomJS.
      #:phantomjs_logger => File.open('/dev/null')
    }
  end
end

