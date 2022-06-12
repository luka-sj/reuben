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
    cmd.string('message', 'Message to broadcast to server.')
    cmd.string('channel', 'Channel to broadcast to.')
    cmd.string('embed', 'Specify a system embed to attach.')
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
    get_broadcast_channel || channel_id('BULLETIN')
  end

  def get_broadcast_channel
    return nil unless option(:channel)

    option(:channel).numeric? ? option(:channel) : channel_id(option(:channel).to_s.upcase)
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
