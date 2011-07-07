Given /^I have (\d+) invoices? for that organization$/ do |number_of_invoices|
  number_of_invoices.to_i.times do
    account = Fabricate(:account, instance: Instance.first)
    product = Fabricate(:product, instance: Instance.first, account: account)

    invoice = Fabricate.build(:invoice, instance: Instance.first, organization: Organization.first, state: Invoice::STATES.key(:draft).to_i, lines: [])
    invoice.lines = [
      Fabricate.build(:invoice_line, invoice: nil, product: product, description: 'Test Invoice Line', price_per: 100, quantity: 2)
    ]
    invoice.save!
  end
end

Given /^I go to the invoices page$/ do
  visit '/invoices'
end

Then /^I should see (\d+) invoices?$/ do |number_of_invoices|
  page.find('table.invoices tbody').all('tr').length.should == number_of_invoices.to_i
end

When /^I add an invoice line with (\d+) of "([^"]*)" with description "([^"]*)" and price per set to (\d+)$/ do |quantity, product, description, price_per|

  # Click the correct "add" link.
  if page.all('.invoice-lines .add-first', visible: true).length > 0
    page.find('.invoice-lines .add-first a').click
  else
    page.find('.invoice-lines .add-another a').click
  end

  within(:css, '.invoice-lines-form tbody tr:last') do

    select(product, from: 'Product')
    fill_in('Description', with: description)
    fill_in('Price per', with: price_per)
    fill_in('Quantity', with: quantity)

  end
    
end

Then /^I should be on the page for that invoice$/ do
  page.current_path.should =~ /^\/invoices\/[a-f0-9]+$/
end

Given /^I go to the page for that invoice$/ do
  visit "/invoices/#{Invoice.first.id}"
end

Given /^I go to the pdf page for that invoice using the template "([^"]*)"$/ do |template|
  visit "/invoices/#{Invoice.first.id}.pdf?template=#{template}"
end

Given /^I generate the invoice$/ do
  handle_js_confirm do
    step %{I click the "Generate invoice" content action}
  end
end
