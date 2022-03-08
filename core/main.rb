#-------------------------------------------------------------------------------
#  load system level scripts first
#-------------------------------------------------------------------------------
Dir[
  'core/extensions/**/*.rb',
  'core/console/**/*.rb',
  'config/*.rb',
  'config/initializers/*.rb'
].each { |f| require "#{Dir.pwd}/#{f}" }
#-------------------------------------------------------------------------------
#  install required gems
#-------------------------------------------------------------------------------
class Core::Gemfile
  install
  load
end

Env.run_before_init
#-------------------------------------------------------------------------------
#  load required directories and files on start
#-------------------------------------------------------------------------------
Dir[
  'lib/**/*.rb',
  'app/**/*.rb'
].each { |f| require "#{Dir.pwd}/#{f}" }

require 'discordrb'
#-------------------------------------------------------------------------------
#  start application
#-------------------------------------------------------------------------------
Env.run_after_init
Env.fetch('APPLICATION_MODULE').capitalize.constantize.start
