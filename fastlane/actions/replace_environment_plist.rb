module Fastlane
  module Actions
    
    class ReplaceEnvironmentPlistAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        environment = params[:environment]
        env_dir = params[:environment_dir]

        if other_action.is_environment(environment: environment, environment_dir: env_dir)
          sh "cp #{env_dir}environment-#{environment}.plist #{env_dir}environment.plist"
        else 
          UI.user_error!("'#{environment}' is not an environment!") 
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Replaces environment plist file"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :environment_dir,
                                       env_name: "FL_ENVIRONMENT_DIR",
                                       description: "Directory containing all environments",
                                       verify_block: proc do |value|
                                          UI.user_error!("No environment directory given, pass using `environment_dir: 'directory'`") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :environment,
                                       env_name: "FL_ENVIRONMENT",
                                       description: "Environment to replace the default file with",
                                       verify_block: proc do |value|
                                          UI.user_error!("No environment give, pass using `environment: 'your_environment'`") unless (value and not value.empty?)
                                       end)
        ]
      end

      def self.authors
        ["tkohout"]
      end

      def self.output
        [
          
        ]
      end

    end
  end
end
