module Fastlane
  module Actions
    module SharedValues
      GET_PROJECT_TEAM_VALUE = :GET_PROJECT_TEAM_VALUE
    end

    class GetProjectTeamAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        xcodeproject = ""

        if !params[:xcodeproject_path]
          xcodeproject = Dir["*.xcodeproj"].first
        else 
          xcodeproject = params[:xcodeproject_path]
        end

        UI.user_error!("Could not find xcodeproject") unless xcodeproject != ""

        UI.message "Using #{xcodeproject}"

        team_id = sh "awk -F '=' '/DevelopmentTeam/ {gsub(/^[ \t]+/, \"\", $2); gsub(/[;]+$/, \"\", $2); print $2; exit}' #{xcodeproject}/project.pbxproj"
        team_id = team_id.tr("\n","")
        
        Actions.lane_context[SharedValues::GET_PROJECT_TEAM_VALUE] = team_id

        return team_id
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Returns team that is set in the Xcode project"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :xcodeproject_path,
                                       env_name: "FL_GET_PROJECT_TEAM_XCODEPROJECT_PATH", # The name of the environment variable
                                       description: "Path to Xcodeproject", # a short description of this parameter
                                       optional: true,
                                       )
        ]
      end

      def self.output
        [
          ['GET_PROJECT_TEAM_VALUE', 'The team id set in Xcodeproject']
        ]
      end

      def self.authors
        ["tkohout"]
      end

    end
  end
end
