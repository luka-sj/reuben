#===============================================================================
#  Ruby Discord framework
#===============================================================================
module Discord
  module Commands
    #---------------------------------------------------------------------------
    module Registry
      class << self
        #-----------------------------------------------------------------------
        #  collection of all defined commands
        #-----------------------------------------------------------------------
        def commands
          @commands ||= {}
        end
        #-----------------------------------------------------------------------
        #  collection of all defined event types
        #-----------------------------------------------------------------------
        def event_types
          @event_types ||= []
        end
        #-----------------------------------------------------------------------
        #  register command as part of the main registry
        #-----------------------------------------------------------------------
        def register(command, event)
          commands[event] = [] unless commands.key?(event)
          commands[event].push(command)
        end
        #-----------------------------------------------------------------------
        #  get all commands belonging to a specific event
        #-----------------------------------------------------------------------
        def get(event)
          commands[event] || []
        end
        #-----------------------------------------------------------------------
        #  send registry request to discord API
        #-----------------------------------------------------------------------
        def route
          register_slash_commands
          event_types.each do |event|
            register_generic_action(event)
          end
        end
        #-----------------------------------------------------------------------
        private
        #-----------------------------------------------------------------------
        #  register all available slash commands
        #-----------------------------------------------------------------------
        def register_slash_commands
          commands[:slash_command]&.each do |command|
            Discord.bot.register_application_command(command.get(:name), command.get(:description), server_id: Discord.test_server_id) do |cmd|
              command.get(:structure).call(cmd) if command.has?(:structure)
            end

            Discord.bot.application_command(command.get(:name)) do |event|
              command.new(event).run
            end
          end
        end
        #-----------------------------------------------------------------------
        #  register generic action
        #-----------------------------------------------------------------------
        def register_generic_action(action)
          return unless Discordrb::EventContainer.instance_methods(false).include?(action)

          Discord.bot.method(action).call do |event|
            Discord::Commands::Registry.commands[action]&.each do |command|
              command.new(event).run
            end
          end
        end
        #-----------------------------------------------------------------------
      end
    end
    #---------------------------------------------------------------------------
  end
end
