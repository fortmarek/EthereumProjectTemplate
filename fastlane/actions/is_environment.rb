module Fastlane
  module Actions
    
    class IsEnvironmentAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        environment = params[:environment]
        env_dir = params[:environment_dir]

        main_dir = File.expand_path("../", Fastlane::FastlaneFolder.path)
        env_dir = File.expand_path(env_dir, main_dir)
        
        return File.file?("#{env_dir}/environment-#{environment}.plist")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Returns whether passed argument is an environment"
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
                                       description: "Environment to check",
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
