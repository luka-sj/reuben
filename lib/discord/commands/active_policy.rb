#===============================================================================
#  Ruby Discord framework
#===============================================================================
module Discord
  module Commands
    #---------------------------------------------------------------------------
    module Policy
      #-------------------------------------------------------------------------
      #  check if running user is moderator
      #-------------------------------------------------------------------------
      def user_moderator?
        authorize_role(:moderator)
      end
      #-------------------------------------------------------------------------
      #  check if running user is admin
      #-------------------------------------------------------------------------
      def user_admin?
        authorize_role(:admin)
      end
      #-------------------------------------------------------------------------
      #  check if user is bot owner
      #-------------------------------------------------------------------------
      def user_owner?
        return unauthorized_access unless Discord.owner == recipient.id.to_s

        true
      end
      #-------------------------------------------------------------------------
      private
      #-------------------------------------------------------------------------
      #  find role for authorization
      #-------------------------------------------------------------------------
      def authorize_role(role)
        server_role = Database::DiscordBot::Sysroles.find_by(role: role.to_s, serverid: server.id)

        return unauthorized access unless server_role

        return unauthorized_access unless recipient.roles.map(&:id).map(&:to_s).include?(server_role.roleid)

        true
      end
      #-------------------------------------------------------------------------
      #  return unauthorized access message
      #-------------------------------------------------------------------------
      def unauthorized_access
        event.respond(content: 'You are not authorized to run this command.', ephemeral: true)

        false
      end
      #-------------------------------------------------------------------------
    end
    #---------------------------------------------------------------------------
  end
end
