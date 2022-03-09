#===============================================================================
#  Ruby Discord framework
#===============================================================================
module Discord
  class << self
    attr_reader :bot
    #---------------------------------------------------------------------------
    #  initialize Discord bot client
    #---------------------------------------------------------------------------
    def initialize
      log 'Initializing Discord bot ...'
      @bot = Discordrb::Bot.new(token: Env.fetch('DISCORD_TOKEN'), intents: [:server_messages])
    rescue
      Env.error('Failed to initialize Discord bot!')
    end
    #---------------------------------------------------------------------------
    #  route all commands
    #---------------------------------------------------------------------------
    def route
      Discord::Commands::Registry.route
    rescue
      Env.error('Failed to bind bot actions!')
    end
    #---------------------------------------------------------------------------
    #  start discord bot
    #---------------------------------------------------------------------------
    def start
      log 'Starting Discord bot ...'
      bot.run
    rescue
      Env.error('Failed to start Discord bot')
    end
    #---------------------------------------------------------------------------
  end
end
