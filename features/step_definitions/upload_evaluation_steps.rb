Given(/^User is on the import page$/) do
  visit '/evaluation/import'
end

Then(/^User should be on the import page$/) do
  current_path.should == "/evaluation/import"
end

When(/^User selects excel file$/) do
  page.attach_file("data_file", Rails.root + 'spec/fixtures/StatisticsReport.xlsx')
end

When(/^User selects a non-excel file$/) do
  page.attach_file("data_file", Rails.root + 'spec/fixtures/ruby-capybara.zip')
end

Then(/^User should see ([0-9]+) new evaluations imported. ([0-9]+) evaluations updated.$/) do |numNew, numUpdate|
  expect(page).to have_content("#{numNew} new evaluations imported. #{numUpdate} evaluations updated.")
end

Then(/^User should see message stating (.+)$/) do |message|
  expect(page).to have_content(message)
end
