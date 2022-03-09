#===============================================================================
#  Extension class to install and run required Ruby gems
#===============================================================================
module Core
  class Gemfile
    class << self
      #-------------------------------------------------------------------------
      #  register gem as dependency
      #-------------------------------------------------------------------------
      def gem(name, gem_alias = nil)
        gem_alias ||= name
        gems.push([name, gem_alias]) unless gems.include?([name, gem_alias])
      end
      #-------------------------------------------------------------------------
      #  list all gem dependencies
      #-------------------------------------------------------------------------
      def gems
        @gems ||= []
      end
      #-------------------------------------------------------------------------
      #  load all installed gems
      #-------------------------------------------------------------------------
      def load
        gems.each do |gem|
          require gem.second
        rescue LoadError
          log "Gem error: unable to load gem #{gem.second}!."
        end
      end
      #-------------------------------------------------------------------------
      #  install all required gems
      #-------------------------------------------------------------------------
      def install
        return if Env.fetch('SKIP_GEM_INSTALL')&.downcase == 'true'

        # initial output
        log 'Checking `Gemfile` for dependencies ...'
        # iterate through all registered gems
        gems.each do |gem|
          # check if gem already installed on system
          if system("gem list -i #{gem.first} > nul")
            log "--> gem `#{gem.first}` already installed."
            next
          end

          # install gem if required
          log "--> installing gem `#{gem.first}`..."
          status = system("gem install #{gem.first} > nul")
          # return status and delete gem from registry if install failed
          gems.delete(gem.first) unless status
        end
        # print output to console
        File.delete('nul') if File.exist?('nul')
        log 'All gem dependencies have been satisfied.'
      end
      #-------------------------------------------------------------------------
    end
  end
end
