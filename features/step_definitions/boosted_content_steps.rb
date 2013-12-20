Given /^the following Boosted Content Keywords exist for the entry titled "([^\"]*)"$/ do |title, fields|
  boosted_content = BoostedContent.find_by_title title
  boosted_content.boosted_content_keywords.delete_all
  fields.raw.flatten.each do |value|
    boosted_content.boosted_content_keywords.build(value: value)
  end
  boosted_content.save!
  boosted_content.index
  Sunspot.commit
end

Given /^the following Boosted Content entries exist for the affiliate "([^\"]*)"$/ do |aff_name, table|
  affiliate = Affiliate.find_by_name aff_name
  sites = table.hashes.collect do |hash|
    hash[:affiliate] = affiliate
    hash[:status] = 'active' if hash[:status].blank?
    publish_start_on = hash[:publish_start_on]
    publish_start_on = Date.current if publish_start_on == 'today'
    publish_start_on = Date.current.send(publish_start_on.to_sym) if publish_start_on.present? and publish_start_on =~ /^[a-zA-Z_]*$/
    publish_start_on = Date.current if publish_start_on.blank?
    hash[:publish_start_on] = publish_start_on

    publish_end_on = hash[:publish_end_on]
    publish_end_on = Date.current if publish_end_on == 'today'
    publish_end_on = Date.current.send(publish_end_on.to_sym) if publish_end_on.present? and publish_end_on =~ /^[a-zA-Z_]*$/
    hash[:publish_end_on] = publish_end_on

    BoostedContent.create! hash
  end
  Sunspot.index(sites) # because BoostedContent has auto indexing turned off for saves/creates
end

When /^I press "([^\"]*)" on the (\d+)(?:st|nd|rd|th) boosted content entry$/ do |button, pos|
  within(".boosted-content-list table tbody tr.row-item:nth-child(#{pos.to_i + 1})") { click_button(button) }
end

Then /^I should see (\d+) Best Bets Texts?$/ do |count|
  page.should have_selector('#best-bets .boosted-content', count: count)
end

And /^I should see boosted content keyword "([^\"]*)"$/ do |keyword|
  page.should have_selector(".keywords span", :text => keyword)
end
