#===============================================================================
#  Application handling module
#===============================================================================
module Reuben
  #-----------------------------------------------------------------------------
  class << self
    #---------------------------------------------------------------------------
    #  start application logic
    #---------------------------------------------------------------------------
    def start
      app_load_schema

      log "Starting Reuben v#{Env::REUBEN_VERSION}"
      Database::Connector.connect
      Discord.initialize
      Discord.route
      Discord.start
    rescue
      Env.error('Failed to start Reuben application!')
    end
    #---------------------------------------------------------------------------
    #  load database schema
    #---------------------------------------------------------------------------
    def app_load_schema
      return unless Env.flag?(:load_schema)

      begin
        schema = File.read("#{Dir.pwd}/db/schema.sql").parse_erb
        Database::Connector.connect(:main)
        log 'Loading database schema ...'
        Database::Connector.query(schema, :main)
        log 'Schema loaded successfully!'
        exit 1
      rescue
        Env.error('Failed to load schema!')
      end
    end
    #---------------------------------------------------------------------------
  end
  #-----------------------------------------------------------------------------
end
