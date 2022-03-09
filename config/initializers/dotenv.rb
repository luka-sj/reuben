#===============================================================================
#  Dotenv initializer
#===============================================================================
require 'dotenv'

Dotenv.load

Dotenv.require_keys(
  'MYSQL_HOST',
  'MYSQL_USERNAME',
  'MYSQL_PASSWORD',
  'BOT_TOKEN',
  'RELEASE'
)
