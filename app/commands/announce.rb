#===============================================================================
#  Command to issue welcome message on server joins
#===============================================================================
class AnnounceCommand < Discord::Commands::BaseCommand
  #-----------------------------------------------------------------------------
  #  command should trigger on
  event :slash_command
  #-----------------------------------------------------------------------------
  #  command metadata
  name  :announce
  description 'Announce message from bot.'

  structure do |cmd|
    cmd.string('message', 'Message to broadcast to server')
  end

  register
  #-----------------------------------------------------------------------------
  #  check if can run command
  #-----------------------------------------------------------------------------
  def trigger?
    admin_role?
  end
  #-----------------------------------------------------------------------------
  #  command action to run when triggered
  #-----------------------------------------------------------------------------
  def action
    bot.send_message(channel_id('BULLETIN'), option(:message))
    event.respond(content: "I'll let everyone know :slight_smile:")
  end
  #-----------------------------------------------------------------------------
end
