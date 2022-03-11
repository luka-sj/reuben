#===============================================================================
#  Ruby Discord framework
#===============================================================================
module Discord
  module ServerInfo
    #-------------------------------------------------------------------------
    #  get server info from Database
    #-------------------------------------------------------------------------
    def server_info
      @server_info ||= Database::Discord::Servers.find_by(server_id: server.id)
    end
    #-------------------------------------------------------------------------
    #  get channel info from database
    #-------------------------------------------------------------------------
    def channel_info
      @channel_info ||= Database::Discord::Channels.find_by(server_id: server.id, channel_id: channel.id)
    end
    #-------------------------------------------------------------------------
    #  get all channels from database
    #-------------------------------------------------------------------------
    def channels_info
      @channels_info ||= Database::Discord::Channels.where(server_id: server.id).all
    end
    #-------------------------------------------------------------------------
    #  check if channel exists
    #-------------------------------------------------------------------------
    def channel?(name)
      channels_info.map(&:name).include?(name)
    end
    #-------------------------------------------------------------------------
    #  get channel info from name
    #-------------------------------------------------------------------------
    def get_channel(name)
      channels_info.select { |chan| chan.name == name }.first
    end
    #-------------------------------------------------------------------------
    #  get channel id from name
    #-------------------------------------------------------------------------
    def channel_id(name)
      channels_info.select { |chan| chan.name == name }.first&.channel_id
    end
    #---------------------------------------------------------------------------
  end
end
