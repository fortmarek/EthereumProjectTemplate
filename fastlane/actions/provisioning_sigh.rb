module Fastlane
  module Actions
    class ProvisioningSighAction < Action
      def self.run(params)
        
        if params[:use_wildcard]
          identifier = ENV["ACK_ENTERPRISE_WILDCARD"]
        else 
          identifier = params[:app_identifier]
        end

        UI.user_error!("No app identifier given, pass using `app_identifier: 'identifier'`") unless (identifier and not identifier.empty?)


        other_action.sigh(
          username: params[:username],
          app_identifier: identifier,
          team_id: params[:team_id]
        )

        # Have to pass Profile path to force use this profile instead whatever is set in xcode (only for ci)
        if params[:configuration] && other_action.is_ci 
          other_action.update_project_provisioning(
            profile: lane_context[SharedValues::SIGH_PROFILE_PATH], 
            build_configuration: params[:configuration]
          )
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Provisioning using sigh"
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
         FastlaneCore::ConfigItem.new(key: :configuration,
                                     description: "Configuration to set the provisioning profile to",
                                     optional: true),
         FastlaneCore::ConfigItem.new(key: :use_wildcard,
                                     description: "Set true to use the enterprise wildcard",
                                     default_value: false,
                                     is_string: false,
                                     optional: true),
        FastlaneCore::ConfigItem.new(key: :app_identifier,
                                     short_option: "-a",
                                     env_name: "SIGH_APP_IDENTIFIER",
                                     description: "The bundle identifier of your app",
                                     optional: true
                                     ),
        FastlaneCore::ConfigItem.new(key: :username,
                                     short_option: "-u",
                                     env_name: "SIGH_USERNAME",
                                     description: "Your Apple ID Username"),
        FastlaneCore::ConfigItem.new(key: :team_id,
                                     short_option: "-b",
                                     env_name: "SIGH_TEAM_ID",
                                     description: "The ID of your team if you're in multiple teams",
                                     optional: true,
                                     )
        ]
      end

      def self.output
        [
        ]
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["tkohout"]
      end

    end
  end
end
