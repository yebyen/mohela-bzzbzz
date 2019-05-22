#require 'ap'
#require_relative "../secrets"

module BigDecimalWithCommasSupport
  def initialize(*args)
    if args.first.is_a?(String) && args.first=~/,/
      args.first.gsub!(',','')
    end
    super(*args)
  end
end

    #alias_method_chain :new, :commas
BigDecimal.send(:prepend, BigDecimalWithCommasSupport)

class Nelnet
  include Capybara::DSL

  BASE_URL = 'https://www.nelnet.com/welcome'

  def initialize
    @@total = 0
    start
  end

  def self.currency_to_number(currency_value)
    (currency_value.is_a? String) ? currency_value.scan(/[.0-9]/).join.to_d : currency_value
  end

  def self.thing(loans)
    bee = Beeminder::User.new AUTH_TOKEN #, :auth_type => :oauth
    any_changes = false
    goals = { "233400-56"=> 0,
              "1100000-34"=> 1 }
    goals.each do |s, i| #slug, index
      l = loans[i]
      g = bee.goal s
      if ((l[:outstanding_balance].to_s != g.curval.to_s) || (g.datapoints.first.updated_at.to_date<Date.today))
        #$stderr.puts "#{g.slug}: #{l}==#{g.curval} (#{l.to_s==g.curval.to_s})"
        any_changes = true
        puts "Updating #{g.slug}"
        dp = Beeminder::Datapoint.new :value => l[:outstanding_balance], :comment => "autodata from nelnet-bzzbzz"
        g.add dp
      end
      @@total += l[:outstanding_balance]
    end #fiber goes here
    if any_changes
      $stderr.puts "Total Loan Balance: #{@@total}"
      goal_aggr = { "mooloans" => nil }
      goal_aggr.each do |s, l|
        g = bee.goal s
        puts "Updating #{g.slug} (aggregate goal)"
        dp = Beeminder::Datapoint.new :value => (@@total), :comment => "autodata from nelnet-bzzbzz"
        g.add dp
      end
    end
  end

private

  def start
    handle_secrets

    loans = all('.col-sm-12.account-detail.m-none.ng-scope')

    table = loans.map(&:text)
    ls = loan_table(table)

    puts "Looking up 2 loans"
    loans = check_loans_type(ls)
    puts "Found 2 loans"
    Nelnet::thing(loans)
  end

  def check_loans_type(loans)
    #ap loans
    ls = loans.map do |l|
      Kernel.exit(1) unless l.class==MatchData
      Kernel.exit(1) unless l.captures.count == 10
      l.captures.each {|d| Kernel.exit(1) unless d.class==String }
      Kernel.exit(1) unless result = l.captures[0].match(/([A-Z])/)
      group = result.captures[0]
      Kernel.exit(1) unless due_on = Date.strptime(l.captures[1], "%m/%d/%Y")
      Kernel.exit(1) unless fee = BigDecimal.new(l.captures[2])
      status = l.captures[3]
      Kernel.exit(1) unless interest_rate = BigDecimal.new(l.captures[4])
      Kernel.exit(1) unless accrued = BigDecimal.new(l.captures[5])
      Kernel.exit(1) unless last_payment = BigDecimal.new(l.captures[6])
      Kernel.exit(1) unless last_paid_on = Date.strptime(l.captures[7], "%m/%d/%Y")
      Kernel.exit(1) unless outstanding_balance = BigDecimal.new(l.captures[8])
      Kernel.exit(1) unless principal_balance = BigDecimal.new(l.captures[9])
      { group: group, due_on: due_on, fee: fee,
        status: status, interest_rate: interest_rate,
        accrued: accrued, last_payment: last_payment,
        last_paid_on: last_paid_on,
        outstanding_balance: outstanding_balance,
        principal_balance: principal_balance }
    end
    Kernel.exit(1) unless ls.length==2
    ls
  end

  def loan_table(ls)
    ls.map do |l|

    t = l.match(%r{Group: ([A-Z])\nDue Date: (\d+/\d+/\d+)\nFees: \$([\d,]+\.\d\d)\nStatus: ([A-Z]+)\nInterest Rate: (\d+\.\d+)%\nAccrued Interest: \$([\d,]+\.\d\d)\nLast Payment Received: \$([\d,]+\.\d\d) on (\d+/\d+/\d+)\nOutstanding Balance: \$([\d,]+.\d\d)\nPrincipal Balance: \$([\d,]+\.\d\d)\nShow Group [A-Z] Loans and Benefits})
    end
  end

  def handle_secrets
    puts "Visiting #{BASE_URL}"
    visit BASE_URL
    #sleep 10
    #puts page.body
    form = find(:css, 'form.ng-pristine.ng-valid', text: "Log In")

    username = NELNET_USERNAME
    password = NELNET_WORD

    within form do
      puts "Logging in..."
      sleep 1
      find "#username"
      fill_in "username", :with => username
      click_on "Log In"
    end

    form2 = find(:css, '#enter-password')

    within form2 do
      find "#Password"
      print "Entering password"
      fill_in "Password", with: NELNET_WORD
      click_on "Submit"
    end
    puts ". Done"

    sleep 5
    find('#maincontent')

    sleep 1
    find('div#area-one-paymentdue')
    sleep 1
    find('div.default-tile h2.panel-title', text: 'Account Details')

    sleep 1
    find('a', text: 'Current Balance:')
    click_on 'Current Balance:'

    sleep 1

    find('h4', text: 'Loan Details')
    sleep 1

    ls = all('.col-sm-12.account-detail.m-none.ng-scope')

  end

end

