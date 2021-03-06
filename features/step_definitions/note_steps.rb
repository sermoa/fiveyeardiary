include ApplicationHelper

When /^I (?:try to )?log a note for (yesterday|today|tomorrow) with the following:$/ do |day, content|
  date = Date.send(day).to_s
  @note_content = content
  log_note(content, date: date)
end

When /^I log a note with the following:$/ do |content|
  @note_content = content
  log_note(content)
end

Given /^I logged a note (\d+) (day|week)s? ago with the following:$/ do |number, period, content|
  date = Date.today - number.to_i.send(period.pluralize.to_sym)
  @previous_note_content = content
  log_note(content, date: date)
end

Given /^I logged a note on the (\d+)(?:st|nd|rd) day of last month with the following:$/ do |number, content|
  date = (Date.today - 1.month).change(day: number.to_i)
  @previous_note_content = content
  log_note(content, date: date)
end

When /^I log a note for the (\d+)st day of this month with the following:$/ do |number, content|
  date = Date.today.change(day: number.to_i)
  @note_content = content
  log_note(content, date: date)
end

When /^I try to log a note$/ do
  visit new_note_path
end

When /^I (?:try to )?view the diary for (yesterday|today)/ do |day|
  date = Date.send(day)
  visit daily_diary_path(date.strftime('%B').downcase, date.day)
end

When /^I go to the week day page for the current day of the week/ do
  date = Date.today
  visit week_day_diary_path(date.strftime('%A'))
end

When /^I go to the week page for the current week$/ do
  date = Date.today
  visit week_diary_path(date.year, date.cweek)
end

When /^I go to the day of month page for day (\d+)$/ do |number|
  visit day_of_month_diary_path(number)
end

When /^I go to the previous week$/ do
  click_link 'previous week'
end

When /^I edit the note and change the date to yesterday/ do
  within('.note') { click_link 'Edit note' }
  fill_in 'Date', with: Date.yesterday
  click_button 'Update note'
end

Then /^I should see the note$/ do
  within('.note') { page.should have_content @note_content }
end

Then /^I should see the previous note$/ do
  within('.note') { page.should have_content @previous_note_content }
end

Then /^I should see both notes$/ do
  within('.notes .note:nth-child(1)') { page.should have_content @previous_note_content }
  within('.notes .note:nth-child(2)') { page.should have_content @note_content }
end

Then /^I should only see the latest note$/ do
  page.should have_no_content @previous_note_content
  page.should have_content @note_content
end

Then /^I should be told that I cannot log a note in the future$/ do
  page.should have_content "cannot be in the future"
end

Then /^I should be told that I cannot log two notes for the same day$/ do
  page.should have_content "You have already made a note for this day"
end

Then /^the date should be set to yesterday$/ do
  page.should have_css('h1', content: friendly_date(Date.yesterday))
end

def log_note(content, options={})
  visit new_note_path
  fill_in "Date", with: options[:date] if options[:date]
  fill_in "note_content", with: content
  click_button "Save note"
end
