source 'https://rubygems.org'

gem 'parslet' , :git => 'https://github.com/NigelThorne/parslet.git'

group 'develop' do
  gem 'travis'
  gem 'byebug'
  gem 'pry-rescue', github: 'ConradIrwin/pry-rescue', ref: :master
  gem 'pry-stack_explorer'
  gem 'yard'
end

group 'test' do
  gem 'rspec'
  gem 'coveralls', require: false
  gem 'simplecov'
  gem "codeclimate-test-reporter", require: nil
end
