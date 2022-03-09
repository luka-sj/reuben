#===============================================================================
#  Command to issue welcome message on server joins
#===============================================================================
class SystemCommand < Discord::Commands::BaseCommand
  #-----------------------------------------------------------------------------
  #  command should trigger on
  event :slash_command
  #-----------------------------------------------------------------------------
  #  command metadata
  name  :system
  description 'Run system actions on Reuben.'

  structure do |cmd|
    cmd.string('action', 'System action to run on Reuben')
  end

  register
  #-----------------------------------------------------------------------------
  #  check if can run command
  #-----------------------------------------------------------------------------
  def trigger?
    user_owner?
  end
  #-----------------------------------------------------------------------------
  #  command action to run when triggered
  #-----------------------------------------------------------------------------
  def action
    case option(:action)&.downcase&.to_sym
    when :stop
      event.respond(content: 'Shutting down ... see you later!', ephemeral: true)
      bot.stop
    when :restart
      event.respond(content: 'Restarting ... see you in a bit!', ephemeral: true)
      bot.stop
      exec('systemctl restart reuben')
    end
  end
  #-----------------------------------------------------------------------------
end
