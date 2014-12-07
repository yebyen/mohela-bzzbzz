#!/usr/bin/env ruby
require 'ap'

text = "Select Disbursement Date Loan Type Current Principal Balance ($) Current Interest Rate (%) Outstanding Interest ($) Late Fees Due ($) 07/13/06 Direct Unsubsidized Consolidation Loan 1,234.56 1.230 12.34 0.00 08/25/06 Direct Unsubsidized Stafford Loan 5,678.01 2.340 56.78 0.00 08/27/08 Direct Unsubsidized Stafford Loan 5,678.12 3.450 1.23 0.00 12/07/09 Direct Subsidized Stafford Loan 7,890.56 4.560 9.78 0.00 12/07/09 Direct Unsubsidized Stafford Loan 5,432.10 9.870 65.43 0.00"

t = text.match(/Select Disbursement Date Loan Type Current Principal Balance \(\$\) Current Interest Rate \(\%\) Outstanding Interest \(\$\) Late Fees Due \(\$\) (.*)/)
data = t[1]
table = data.scan(/(\d+\/\d\d\/\d\d) ([a-zA-Z ]+) ([\d,.]+) ([\d,.]+) ([\d,.]+) ([\d,.]+) ?/)
ap table


