#===============================================================================
#  Ruby MySQL Database framework
#===============================================================================
module Database
  #-----------------------------------------------------------------------------
  #  connector module
  #-----------------------------------------------------------------------------
  module Connector
    class << self
      attr_reader :client
      #-------------------------------------------------------------------------
      #  store of all database names
      #-------------------------------------------------------------------------
      def databases
        @databases ||= []
      end
      #-------------------------------------------------------------------------
      #  connect to MySQL instance
      #-------------------------------------------------------------------------
      def connect
        @client = {}
        #  load configuration file
        log 'Starting MySQL database connection:'
        config = YAML.parse_hash('./config/database.yml')
        #  iterate through configuration file and create DB connections
        config.each do |db, conf|
          next if db.downcase.eql?('default')

          #  store loaded database names
          databases << db
          log "--> connecting to `#{db}` ..."
          @client[db.to_sym] = Mysql2::Client.new(
            host: conf['host'],
            username: conf['username'],
            password: conf['password'],
            database: db.to_s
          )
        end
        log 'MySQL database connected!'
        #  run schema generation to create new Database::Objects
        log 'Generating database schema ... '
        Database::Schema::Generator.run
      rescue
        Env.error('Failed to connect to MySQL database!')
      end
      #-------------------------------------------------------------------------
      #  query database content
      #-------------------------------------------------------------------------
      def query(sql, database = :discord_bot)
        return nil unless client.key?(database)

        client[database]&.query(sql)
      rescue
        Env.error('Failed to query MySQL database!')
      end
      #-------------------------------------------------------------------------
    end
    #---------------------------------------------------------------------------
  end
end
