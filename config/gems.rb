#===============================================================================
#  Configure required gems for console application
#===============================================================================
class Core::Gemfile
  gem 'activesupport', 'active_support'
  gem 'clockwork'
  gem 'erb'
  gem 'dotenv'
  gem 'json'
  gem 'mysql2'
  gem 'pry'
  gem 'rubyzip', 'zip'
  gem 'securerandom'
  gem 'yaml'
  gem 'zlib'
end

Dir["#{Dir.pwd}/gems/**/lib"].each { |dir| $LOAD_PATH << dir }
