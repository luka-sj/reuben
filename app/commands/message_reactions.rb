#===============================================================================
#  Reuben applies message reactions based on dictionary file
#===============================================================================
class MessageReactionsCommand < Discord::Commands::BaseCommand
  #-----------------------------------------------------------------------------
  #  command should trigger on
  event :message
  #-----------------------------------------------------------------------------
  #  command metadata
  name  :reactions
  description 'Leave reactions on messages.'

  register
  #-----------------------------------------------------------------------------
  #  command action to run when triggered
  #-----------------------------------------------------------------------------
  def action
    File.readlines("#{Dir.pwd}/app/texts/dictionary/reactions.txt").each do |line|
      reaction = line.chomp.split(',')
      next unless message.content.downcase.include?(reaction.first)

      message.react(reaction.second)
      break
    rescue
      log 'Failed to react with emoji', :error
    end
  end
  #-----------------------------------------------------------------------------
end
