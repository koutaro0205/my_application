# RSpec.configure do |config|
#   config.before(:each, type: :system) do
#     driven_by :rack_test
#   end

#   config.before(:each, type: :system, js: true) do
#     driven_by :selenium_chrome_headless
#   end
# end
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless
  end
end
Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_chrome_headless