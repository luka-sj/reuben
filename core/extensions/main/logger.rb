#===============================================================================
#  System logger
#===============================================================================
module Core
  module Logger
    #---------------------------------------------------------------------------
    #  logger object
    #---------------------------------------------------------------------------
    class << self
      #-------------------------------------------------------------------------
      #  log message to console and file
      #-------------------------------------------------------------------------
      def log(msg, level = :info)
        log_msg = "#{timestamp} [#{level.to_s.upcase}] #{msg}\n"

        #  log to console
        print log_msg
        #  log to database
        begin
          if database?
            Database::Logs::Logs.create(
              level: level.to_s.upcase,
              message: msg,
              timestamp: Time.now.strftime('%H:%M:%S %d %B %Y'),
              instance: Env.fetch('DEPLOYEMENT'),
              ip: nil
            )
          end
        rescue
          print 'Could not log to database!'
        end
        #  log to file
        File.open("./logs/#{level}.txt", 'a') { |file| file.write(log_msg) }
      end
      #-------------------------------------------------------------------------
      #  get formatted timestamp
      #-------------------------------------------------------------------------
      def timestamp
        Time.now.strftime('[%Y-%m-%d %H:%M:%S %Z]')
      end
      #-------------------------------------------------------------------------
      #  check if can log to database
      #-------------------------------------------------------------------------
      def database?
        Database && Database.const_defined?(:Logs) && Database::Logs.const_defined?(:Logs)
      end
      #-------------------------------------------------------------------------
    end
  end
end
#-------------------------------------------------------------------------------
#  Kernel function for logging
#-------------------------------------------------------------------------------
def log(msg, level = :info)
  Core::Logger.log(msg, level)
end
