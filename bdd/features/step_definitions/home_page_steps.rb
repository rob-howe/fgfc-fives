Given /^I goto the home page$/ do
  visit '/'
end

Then /^I should see the top heading with '(.*)'$/ do |heading|
  expect(page.find('#top_heading').text).to eq heading
end