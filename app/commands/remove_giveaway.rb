#===============================================================================
#  Command to remove users from giveaway(s) once they leave the server
#===============================================================================
class RemoveGiveawayCommand < Discord::Commands::BaseCommand
  #-----------------------------------------------------------------------------
  #  command should trigger on
  event :member_leave
  #-----------------------------------------------------------------------------
  #  command metadata
  name  :remove_giveaway
  description 'Removes member from giveaway(s) when leaving server.'

  register
  #-----------------------------------------------------------------------------
  #  command action to run when triggered
  #-----------------------------------------------------------------------------
  def action
    user_id = "discord#{recipient.id}##{recipient.discriminator}"
    Database::Main::GiveawayEntries.where(claimed: 0, entry: user_id).all.each(&:delete)
  end
  #-----------------------------------------------------------------------------
end
