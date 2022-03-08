#===============================================================================
#  Command to issue welcome message on server joins
#===============================================================================
class WelcomeMessageCommand < Discord::Commands::BaseCommand
  #-----------------------------------------------------------------------------
  #  command should trigger on
  event :member_join
  #-----------------------------------------------------------------------------
  #  command metadata
  name  :welcome_message
  description 'Show welcome message when user joins Discord server.'

  register
  #-----------------------------------------------------------------------------
  #  command action to run when triggered
  #-----------------------------------------------------------------------------
  def action
    register_user
    bot.send_message(channel_id('WELCOME'), "<@#{recipient.id}>", false, WelcomeEmbed.new(event).output)
  end
  #-----------------------------------------------------------------------------
  #  register user in main database
  #-----------------------------------------------------------------------------
  def register_user
    # user_avatar = "https://cdn.discordapp.com/avatars/#{recipient.id}/#{recipient.avatar}"
    user_id  = "discord#{recipient.id}##{recipient.discriminator}"
    salt     = SecureRandom.hex(128)
    password = (Digest::SHA256.new << salt).hexdigest

    existing = Database::Main::Users.find_by(userid: user_id)
    return existing.update(displayname: recipient.username, active: 1) if existing

    Database::Main::Users.create(
      username: user_id,
      displayname: recipient.username,
      password: password,
      salt: salt,
      userid: user_id,
      usrlink: user_id,
      active: 1,
      discord: recipient.discriminator
    )
  end
  #-----------------------------------------------------------------------------
end
