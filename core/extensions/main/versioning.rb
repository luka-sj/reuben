#===============================================================================
#  Helper module for softvare versioning
#===============================================================================
module Extensions
  #-----------------------------------------------------------------------------
  module Versioning
    class << self
      #-------------------------------------------------------------------------
      #  converts versioning string to numeric output
      #-------------------------------------------------------------------------
      def to_i(string)
        versionable = string.split('.')
        (3 - versionable.count).times { versionable << '0' }

        versionable.map { |v| v.rjust(5, '0') }.join('').to_i
      end
      #-------------------------------------------------------------------------
    end
  end
  #-----------------------------------------------------------------------------
end
