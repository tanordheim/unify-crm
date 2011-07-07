# encoding: utf-8
# vim:ft=ruby
#

require 'active_support/inflector'

guard 'pow' do
  watch('.powrc')
  watch('.powenv')
  watch('.rvmrc')
  watch('Gemfile.lock')
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/mongoid.yml')
  watch(%r{^config/environments/.*\.rb$})
  watch(%r{^config/initializers/.*\.rb$})
end

guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' }, :test_unit => false, :cucumber => true, :wait => 60 do
  watch('Gemfile.lock')
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/mongoid.yml')
  watch('config/routes.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch(%r{^config/locales/.+\.yml})
  watch('spec/spec_helper.rb')                          { 'spec/' }
  watch(%r{^spec/support/(.+)\.rb$})                    { 'spec/' }
  watch(%r{^features/support/.+\.rb$})                  { 'features' }
  watch(%r{^lib/.+\.rb$})
end

guard 'rspec', :version => 2, :cli => '--drb --color --format nested --fail-fast', :all_on_start => false, :all_after_pass => false, :notification => false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})                             { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')                          { 'spec/' }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                             { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/support/(.+)\.rb$})                    { 'spec/' }
  watch('spec/spec_helper.rb')                          { 'spec/' }
  watch(%r{^spec/fabricators/(.+)_fabricator\.rb$})     { |m| "spec/models/#{m[1]}_spec.rb" }
end

guard 'cucumber', :cli => '--drb --no-profile --color --format progress --strict', :all_on_start => false, :all_after_pass => false do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})                      { 'features' }
  # watch('features/step_definitions/task_steps.rb')      { Dir["features/**/tasks.feature"] + Dir["features/calendars/*.feature"] }
  # watch('features/step_definitions/comment_steps.rb')   { Dir["features/**/comments.feature"] }
  # watch('features/step_definitions/employment_steps.rb'){ ['features/organizations/employees.feature', 'features/people/employments.feature'] }
  # watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir["features/#{m[1].pluralize}/*.feature"] }
  # %w(alert, blank_slate, debug, form, instance, ui).each do |name|
  #   watch("features/step_definitions/#{name}_steps.rb") { 'features' }
  # end
end

guard 'resque', :environment => 'development', :queue => 'geocode_addresses' do
  watch(%r{^app/(.+)\.rb})
  watch(%r{^lib/(.+)\.rb})
end
