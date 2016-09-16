module Fastlane
  module Actions
    
    class GetEnvironmentPlistValueAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        environment = params[:environment]
        env_dir = params[:environment_dir]
        key = params[:key]
        
        if other_action.is_environment(environment: environment, environment_dir: env_dir)
          return other_action.get_info_plist_value(path: "../#{env_dir}/environment-#{environment}.plist", key: key)
        else 
          UI.user_error!("'#{environment}' is not an environment!") 
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Gets value from specified environment plist"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :key,
                                       description: "Key in the plist"
                                       ),
          FastlaneCore::ConfigItem.new(key: :environment_dir,
                                       env_name: "FL_ENVIRONMENT_DIR",
                                       description: "Directory containing all environments",
                                       verify_block: proc do |value|
                                          UI.user_error!("No environment directory given, pass using `environment_dir: 'directory'`") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :environment,
                                       env_name: "FL_ENVIRONMENT",
                                       description: "Environment for which to get the value",
                                       verify_block: proc do |value|
                                          UI.user_error!("No environment given, pass using `environment: 'your_environment'`") unless (value and not value.empty?)
                                       end)
        ]
      end

      def self.authors
        ["tkohout"]
      end

      

    end
  end
end
