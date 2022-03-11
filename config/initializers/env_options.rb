#===============================================================================
#  Parse given options initializer
#===============================================================================
module Env
  class << self
    def options
      @options ||= []
    end

    def option?(key)
      options.include?(key.to_s.gsub('_', '-'))
    end

    def flags
      @flags ||= {}
    end

    def flag?(key)
      flags.keys.include?(key.to_s.gsub('_', '-'))
    end
  end
end
#-------------------------------------------------------------------------------
#  iterate through all passed arguments
#-------------------------------------------------------------------------------
flag = nil
ARGV.each do |arg|
  #  check if previous argument was flag or current argument is last
  if flag || arg.eql?(ARGV[-1])
    key, value = arg.split('=')
    #  check if last argument is a flag type
    if (flag || arg).start_with?('--')
      Env.flags[(flag || arg).gsub(/^\-+/, '')] = true
    #  check if specified flag is environment variable setter
    elsif flag&.upcase.eql?('ENV')
      ENV[key.upcase] = value
    elsif flag
      Env.flags[flag] = arg
    end
  end

  flag = nil
  #  skip if normal argument
  next unless arg.start_with?('-')

  #  push option if not flag
  next Env.options.push(arg.gsub(/^\-+/, '')) unless arg.start_with?('--')
  flag = arg.gsub(/^\-+/, '')
end
