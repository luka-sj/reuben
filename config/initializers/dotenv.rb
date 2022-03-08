#===============================================================================
#  Dotenv initializer
#===============================================================================
require 'dotenv'

Dotenv.load

Dotenv.require_keys(
  'MYSQL_HOST',
  'MYSQL_USERNAME',
  'MYSQL_PASSWORD',
  'DISCORD_TOKEN',
  'DEPLOYEMENT'
)
