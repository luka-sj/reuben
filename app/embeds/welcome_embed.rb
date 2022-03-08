#===============================================================================
#  Embed to welcome users on server joins
#===============================================================================
class WelcomeEmbed < BaseEmbed
  #-----------------------------------------------------------------------------
  #  embed data content
  #-----------------------------------------------------------------------------
  def data
    {}.tap do |embed|
      #  basic components
      embed['type']        = 'image'
      embed['title']       = server_info.name
      embed['thumbnail']   = thumbnail(server_info.icon)
      embed['color']       = color(server_info.color)
      embed['url']         = server_info.url
      embed['description'] = "Hello **#{recipient.username}**! Welcome to the **#{server_info.name}** Discord!"
      #  add server specific fields to the embed
      embed['fields']      = [].tap do |field|
        #  show rules detail
        field.push(
          {
            'name' => "Now that you're here...",
            'value' => read_text(:welcome_intro)
          }
        )
        #  show rules channel
        if channel?('RULES')
          field.push(
            {
              'name' => 'Make sure that you are familiar with the Server rules',
              'value' => "<##{channel_id('RULES')}>",
              'inline' => true
            }
          )
        end
        #  show announcements channel
        if channel?('ANNOUNCEMENTS')
          field.push(
            {
              'name' => "You'll find major Server announcements in",
              'value' => "<##{channel_id('ANNOUNCEMENTS')}>",
              'inline' => true
            }
          )
        end
        #  show bulletin channele
        if channel?('BULLETIN')
          field.push(
            {
              'name' => "Keep tabs on other people's announcements and post your own in",
              'value' => "<##{channel_id('BULLETIN')}>",
              'inline' => true
            }
          )
        end
        #  show resource repository
        field.push(
          {
            'name' => 'Resource Repository',
            'value' => read_text(:welcome_repo)
          }
        )
      end
    end
  end
  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  #  check if channel exists
  #-----------------------------------------------------------------------------
  def channel?(name)
    channels_info.map(&:name).include?(name)
  end
  #-----------------------------------------------------------------------------
  #  get channel info from name
  #-----------------------------------------------------------------------------
  def get_channel(name)
    channels_info.select { |chan| chan.name == name }.first
  end
  #-----------------------------------------------------------------------------
  #  get channel id from name
  #-----------------------------------------------------------------------------
  def channel_id(name)
    channels_info.select { |chan| chan.name == name }.first&.channelid
  end
  #-----------------------------------------------------------------------------
end
