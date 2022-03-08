#===============================================================================
#  Ruby Discord framework
#===============================================================================
module Discord
  class BaseEmbed
    #---------------------------------------------------------------------------
    #  default embed constructor
    #---------------------------------------------------------------------------
    def initialize(event)
      @bot       = event.bot
      @event     = event
      @server    = event.server
      @channel   = event.channel
      @message   = event.message
      @recipient = event.message.author
    end
    #---------------------------------------------------------------------------
    #  default embed data
    #---------------------------------------------------------------------------
    def data
      {}
    end
    #---------------------------------------------------------------------------
    #  send embed to event channel
    #---------------------------------------------------------------------------
    def send
      event.send_embed('', output)
    end
    #---------------------------------------------------------------------------
    #  render as embed object
    #---------------------------------------------------------------------------
    def render
      Discordrb::Embed.new(output, event)
    end
    #---------------------------------------------------------------------------
    #  merge default data with embed specific one
    #---------------------------------------------------------------------------
    def output
      embed_data = data

      embed_data.merge(default_footer) unless embed_data.key?('footer')

      embed_data
    end
    #---------------------------------------------------------------------------
    private
    #---------------------------------------------------------------------------
    attr_reader :bot, :event, :server, :channel, :message, :recipient
    #---------------------------------------------------------------------------
    #  read text from structured files
    #---------------------------------------------------------------------------
    def read_text(filename)
      ERB.new(File.read("#{Dir.pwd}/app/texts/#{filename}.erb")).result(binding)
    end
    #---------------------------------------------------------------------------
    #  parse embed thumbnail properly
    #---------------------------------------------------------------------------
    def thumbnail(url)
      { 'url' => url }
    end
    #---------------------------------------------------------------------------
    #  calculate ember color from hex string
    #---------------------------------------------------------------------------
    def color(color)
      color = color.delete('#')
      red   = color[0...2].to_i(16)
      green = color[2...4].to_i(16)
      blue  = color[4...6].to_i(16)

      (red.to_i << 16 | green.to_i << 8 | blue.to_i)
    end
    #---------------------------------------------------------------------------
    #  apply default footer
    #---------------------------------------------------------------------------
    def default_footer
      {}.tap do |embed|
        embed['footer'] = {
          'text' => "©#{Time.now.year} Luka S.J.",
          'url' => Env.fetch('APP_URL'),
          'icon_url' => 'https://i.imgur.com/jxGPkTR.png'
        }
      end
    end
    #---------------------------------------------------------------------------
    #  get server info from Database
    #---------------------------------------------------------------------------
    def server_info
      @server_info ||= Database::DiscordBot::Servers.find_by(serverid: server.id)
    end
    #---------------------------------------------------------------------------
    #  get channel info from database
    #---------------------------------------------------------------------------
    def channel_info
      @channel_info ||= Database::DiscordBot::Channels.find_by(serverid: server.id, channelid: channel.id)
    end
    #---------------------------------------------------------------------------
    #  get all channels from database
    #---------------------------------------------------------------------------
    def channels_info
      @channels_info ||= Database::DiscordBot::Channels.where(serverid: server.id).all
    end
    #---------------------------------------------------------------------------
  end
end
