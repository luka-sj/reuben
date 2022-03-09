#===============================================================================
#  Ruby Discord framework
#===============================================================================
module Discord
  module Commands
    #---------------------------------------------------------------------------
    class BaseCommand
      class << self
        #-----------------------------------------------------------------------
        #  collection of all attribute metadata
        #-----------------------------------------------------------------------
        def attributes
          @attributes ||= {}
        end
        #-----------------------------------------------------------------------
        #  register for specific bot event
        #-----------------------------------------------------------------------
        def event(event = :message)
          attributes[:event] = event
        end
        #-----------------------------------------------------------------------
        #  set command name
        #-----------------------------------------------------------------------
        def name(name = nil)
          attributes[:name] = name
        end
        #-----------------------------------------------------------------------
        #  set command description
        #-----------------------------------------------------------------------
        def description(description = nil)
          attributes[:description] = description
        end
        #-----------------------------------------------------------------------
        #  define slash command structure block
        #-----------------------------------------------------------------------
        def structure(&block)
          attributes[:structure] = block
        end
        #-----------------------------------------------------------------------
        #  register command in main registry
        #-----------------------------------------------------------------------
        def register
          event = get(:event) || :message

          Discord::Commands::Registry.register(self, event)
          return if Discord::Commands::Registry.event_types.include?(event)

          Discord::Commands::Registry.event_types << event
        end
        #-----------------------------------------------------------------------
        #  get attribute value
        #-----------------------------------------------------------------------
        def get(attribute)
          attributes[attribute]
        end
        #-----------------------------------------------------------------------
        #  check if attribute is defined
        #-----------------------------------------------------------------------
        def has?(attribute)
          attributes.key?(attribute)
        end
      end
      #-------------------------------------------------------------------------
      #  command class constructor
      #-------------------------------------------------------------------------
      include Discord::Commands::Policy

      attr_reader :bot, :event, :server, :channel, :message, :recipient, :options

      def initialize(event)
        @bot       = event.bot
        @event     = event
        @server    = event.respond_to?(:server) ? event.server : nil
        @channel   = event.respond_to?(:channel) ? event.channel : nil
        @message   = event.respond_to?(:message) ? event.message : nil
        @recipient = event.respond_to?(:user) ? event.user : nil
        @options   = event.respond_to?(:options) ? event.options : nil
      rescue
        Env.error('Failed to initialize command!')
      end
      #-------------------------------------------------------------------------
      #  run command callback
      #-------------------------------------------------------------------------
      def run
        return unless trigger?

        action
      rescue
        Env.error('Failed to run action!')
      end
      #-----------------------------------------------------------------------
      #  define command action block
      #-----------------------------------------------------------------------
      def action; end
      #-----------------------------------------------------------------------
      #  define command trigger block
      #-----------------------------------------------------------------------
      def trigger?
        true
      end
      #-------------------------------------------------------------------------
      private
      #-------------------------------------------------------------------------
      #  get command option
      #-------------------------------------------------------------------------
      def option(opt)
        options[opt.to_s]
      end
      #-------------------------------------------------------------------------
      #  get server info from Database
      #-------------------------------------------------------------------------
      def server_info
        @server_info ||= Database::DiscordBot::Servers.find_by(serverid: server.id)
      end
      #-------------------------------------------------------------------------
      #  get channel info from database
      #-------------------------------------------------------------------------
      def channel_info
        @channel_info ||= Database::DiscordBot::Channels.find_by(serverid: server.id, channelid: channel.id)
      end
      #-------------------------------------------------------------------------
      #  get all channels from database
      #-------------------------------------------------------------------------
      def channels_info
        @channels_info ||= Database::DiscordBot::Channels.where(serverid: server.id).all
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
        channels_info.select { |chan| chan.name == name }.first&.channelid
      end
      #-------------------------------------------------------------------------
    end
    #---------------------------------------------------------------------------
  end
end
