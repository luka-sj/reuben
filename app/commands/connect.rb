#===============================================================================
#  Command to issue welcome message on server joins
#===============================================================================
class ConnectCommand < Discord::Commands::BaseCommand
  #-----------------------------------------------------------------------------
  #  command should trigger on
  event :ready
  #-----------------------------------------------------------------------------
  #  command metadata
  name  :connect
  description 'Run code as soon as Reuben connects to Websockets.'

  register
  #-----------------------------------------------------------------------------
  #  command action to run when triggered
  #-----------------------------------------------------------------------------
  def action
    log 'Reuben successfully started!'
    bot.watching = 'cool Ruby tutorials'
  end
  #-----------------------------------------------------------------------------
end
