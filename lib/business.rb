#require_relative "../secrets"

class Business
  include Capybara::DSL

  BASE_URL = 'https://www.mohela.com'

  def initialize
    start
  end

private

  def start
    handle_secrets
    #find(:css, 'a#cphContent_a27')
    click_on "Payoff Calculator"
    save_screenshot('screenshot.png')
    table = find(:css, '#cphContent_cphMainForm_dgLoan')
    loans = loan_table(table.text)
    p loans
  end

  def loan_table(text)
    t = text.match(/Select Disbursement Date Loan Type Current Principal Balance \(\$\) Current Interest Rate \(\%\) Outstanding Interest \(\$\) Late Fees Due \(\$\) (.*)/)
    data = t[1]
    table = data.scan(/(\d+\/\d\d\/\d\d) ([a-zA-Z ]+) ([\d,.]+) ([\d,.]+) ([\d,.]+) ([\d,.]+) ?/)
  end

  def handle_secrets
    visit BASE_URL
    form = find(:css, 'form#form1')
    username = USERNAME

    within form do
      fill_in "cphContent_txtUsername", :with => username
      click_on "Login"
    end

    form = find(:css, 'form#form1')
    sec_question = find(:css, '#cphContent_cphMainForm_lblSecQuestion')

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
      fill_in "cphContent_cphMainForm_txtMyword", :with => MY_WORD
      click_on "Login"
    end

  end

end

