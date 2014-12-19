#require_relative "../secrets"

class Business
  include Capybara::DSL

  BASE_URL = 'https://www.mohela.com'

  def initialize
    start
  end

  def self.thing(loans)
    bee = Beeminder::User.new AUTH_TOKEN #, :auth_type => :oauth
    goals = { "944733-475"=> 0,
              "500700-68"=> 1,
              "246112-68"=> 2,
              "358075-56"=> 3,
              "480897-68"=> 4 }
    goals.each do |s, i| #slug, index
      l = loans[i]
      g = bee.goal s
      if ((l.to_s != g.curval.to_s) || (g.updated_at.to_date<Date.today))
        $stderr.puts "#{g.slug}: #{l}==#{g.curval} (#{l.to_s==g.curval.to_s})"
        puts "Updating #{g.slug}"
        dp = Beeminder::Datapoint.new :value => l, :comment => "autodata from mohela-bzzbzz"
        g.add dp
      end
    end #fiber goes here
  end

private

  def start
    handle_secrets
    #find(:css, 'a#cphContent_a27')
    click_on "Payoff Calculator"
    #save_screenshot('screenshot.png')
    table = find(:css, '#cphContent_cphMainForm_dgLoan')
    loans = loan_table(table.text)

    puts "Looking up 5 loans"
    check_loans_type(loans)

    puts "Adding interest to statement balances"
    loan_balances = []
    loans.each_with_index do |l, i|
      balance = currency_to_number(l[2])
      interest = currency_to_number(l[4])
      loan_balances[i] = (balance + interest)

      #currency_to_number(ActionController::Base.helpers.number_to_currency(1234.75,unit: '$')).to_s

      #$stderr.puts "Loan #{1+i}: #{loan_balances[i]}"
    end
    Business::thing(loan_balances)
  end

  def check_loans_type(loans)
    loans.collect {|b| b.map(&:class)}.each do |c|
      Kernel.exit(1) unless c.class==Array
      c.each {|d| Kernel.exit(1) unless d==String }
      Kernel.exit(1) unless c.length==6
    end
    Kernel.exit(1) unless loans.length==5
  end

  def currency_to_number(currency_value)
    (currency_value.is_a? String) ? currency_value.scan(/[.0-9]/).join.to_d : currency_value
  end

  def loan_table(text)
    t = text.match(/Select Disbursement Date Loan Type Current Principal Balance \(\$\) Current Interest Rate \(\%\) Outstanding Interest \(\$\) Late Fees Due \(\$\) (.*)/)
    data = t[1]
    table = data.scan(/(\d+\/\d\d\/\d\d) ([a-zA-Z ]+) ([\d,.]+) ([\d,.]+) ([\d,.]+) ([\d,.]+) ?/)
  end

  def handle_secrets
    puts "Visiting #{BASE_URL}"
    visit BASE_URL
    form = find(:css, 'form#form1')
    username = USERNAME

    within form do
      puts "Logging in..."
      fill_in "cphContent_txtUsername", :with => username
      click_on "Login"
    end

    form = find(:css, 'form#form1')
    sec_question = find(:css, '#cphContent_cphMainForm_lblSecQuestion')
    puts "Answering security question."

    within form do
      case sec_question.text
      when SECRET_Q1
        fill_in "cphContent_cphMainForm_txtAnswer", :with => SECRET_A1
        click_on "Submit"
      when SECRET_Q2
        fill_in "cphContent_cphMainForm_txtAnswer", :with => SECRET_A2
        click_on "Submit"
      when SECRET_Q3
        fill_in "cphContent_cphMainForm_txtAnswer", :with => SECRET_A3
        click_on "Submit"
      else
        puts sec_question.text
        puts "Don't know, exiting!"
        Kernel.exit(1)
      end
    end

    form = find(:css, 'form#form1')
    within form do
      print "Entering password"
      fill_in "cphContent_cphMainForm_txtMyword", :with => MY_WORD
      click_on "Login"
    end
    puts ". Done"

  end

end

