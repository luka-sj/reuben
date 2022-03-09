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
    cmd.string('channel', 'Channel to broadcast to')
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
    bot.send_message(broadcast_channel, option(:message), false, render_embed)
    event.respond(content: "I'll let everyone know :slight_smile:", ephemeral: true)
  end
  #-----------------------------------------------------------------------------
  #  get channel for broadcasting
  #-----------------------------------------------------------------------------
  def broadcast_channel
    option(:channel) ? option(:channel) : channel_id('BULLETIN')
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
