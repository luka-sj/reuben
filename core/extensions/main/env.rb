#===============================================================================
#  Application environment module
#===============================================================================
module Env
  class << self
    #---------------------------------------------------------------------------
    #  fetch environment variables
    #--------------------------------------------------------------------------
    def fetch(key)
      ENV[key]
    end
    #---------------------------------------------------------------------------
    #  run code blocks at steps of initialization
    #---------------------------------------------------------------------------
    def before_init(&block)
      @run_before_init = block
    end

    def after_init(&block)
      @run_after_init = block
    end

    def run_before_init
      @initial_directory ||= Dir.pwd

      return unless @run_before_init

      @run_before_init.call
    end

    def run_after_init
      return unless @run_after_init

      @run_after_init.call
    end
    #---------------------------------------------------------------------------
    #  log error output
    #---------------------------------------------------------------------------
    def error(msg)
      log msg, :error
      log $ERROR_INFO.message, :error
      log $ERROR_INFO.backtrace.join("\r\n"), :error

      nil
    end
    #---------------------------------------------------------------------------
  end
  #-----------------------------------------------------------------------------
  #  Module to simplify OS detection
  #-----------------------------------------------------------------------------
  module OS
    class << self
      #-------------------------------------------------------------------------
      #  check for OS versions
      def windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
      end

      def mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
      end

      def unix?
        !OS.windows?
      end

      def linux?
        OS.unix? and !OS.mac?
      end

      def get
        ['windows', 'mac', 'linux', 'unix'].each do |try_os|
          return try_os.capitalize if send("#{try_os}?")
        end

        'Unknown'
      end
      #-------------------------------------------------------------------------
    end
  end
  #-----------------------------------------------------------------------------
end
