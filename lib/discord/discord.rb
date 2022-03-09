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
      @bot = Discordrb::Bot.new(token: Env.fetch('BOT_TOKEN'), intents: [:server_messages])
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
    #  get bot owner ID
    #---------------------------------------------------------------------------
    def owner
      Env.fetch('BOT_OWNER')
    end
    #---------------------------------------------------------------------------
    #  check if running a test server
    #---------------------------------------------------------------------------
    def test_server?
      ENV.key?('TEST_SERVER') && ENV.key?('TEST_MODE') && Env.true?('TEST_MODE')
    end

    def test_server_id
      return nil unless test_server?

      Env.fetch('TEST_SERVER')
    end
    #---------------------------------------------------------------------------
  end
end
