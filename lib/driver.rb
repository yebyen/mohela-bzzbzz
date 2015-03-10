class Driver
  NAME = :poltergeist

  # Configures Capybara to use PhantomJS/Poltergeist.
  def self.configure
    Capybara.run_server = false
    register
    Capybara.current_driver = NAME
  end

  def self.register
    Capybara.register_driver(NAME) do |app|
      c = Capybara::Poltergeist::Driver.new(app, options)
      c.headers = { 'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.11 Safari/537.36' }
      c
    end
  end

  def self.options
    {
      :phantomjs => Phantomjs.path,
      # Do not raise Ruby exceptions when JavaScript errors occur.
      :js_errors => false,
      # Suppress "ran insecure content" warnings from PhantomJS.
      :phantomjs_logger => File.open('/dev/null')
    }
  end
end

