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
    user_admin?
  end
  #-----------------------------------------------------------------------------
  #  command action to run when triggered
  #-----------------------------------------------------------------------------
  def action
    bot.send_message(channel_id('BULLETIN'), option(:message), false, render_embed)
    event.respond(content: "I'll let everyone know :slight_smile:", ephemeral: true)
  end
  #-----------------------------------------------------------------------------
  #  return embed if applicable
  #-----------------------------------------------------------------------------
  def render_embed
    return nil unless option(:embed)

    "#{option(:embed).camel_case}Embed".constantize.new(event).output
  end
  #-----------------------------------------------------------------------------
end
