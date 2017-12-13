module Fastlane
  module Actions

    class GetBuildSettingsAction < Action
      def self.run(params)

        if !params[:xcodeproj]
          xcodeproject = Dir["*.xcodeproj"].first
          UI.user_error! ".xcodeproj file was not found in directory" unless xcodeproject
        else
          xcodeproject = params[:xcodeproj]
        end

        target_filter = params[:target_filter]
        configuration_filter = params[:build_configuration]
        key = params[:key]

        project = Xcodeproj::Project.open(xcodeproject)
        target = project.targets.select { |target| !target_filter || target.product_name.match(target_filter) }.first

        UI.user_error! "No target found" unless target

        configuration = target.build_configurations.select { |configuration| configuration.name.match(configuration_filter) }.first
        UI.user_error! "No configuration found" unless configuration

        value = configuration.build_settings[key]
        if value == nil then
            # If the key is not in default configuration, get it from project configuration which it inherits
            value = project.build_settings(configuration.name)[key]
        end

        return value
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Sets value for specified target and configuration"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :xcodeproj,
                                       env_name: "FL_SET_BUILD_SETTINGS_XCODE_PATH",
                                       description: "Path to your Xcode project",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Path to xcode project is invalid") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :key,
                                       env_name: "FL_SET_BUILD_SETTINGS_KEY",
                                       description: "Key of build settings",
                                       verify_block: proc do |value|
                                         UI.user_error!("No key given") unless value and not value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :target_filter,
                                       env_name: "FL_UPDATE_PROVISIONING_NAME_TARGET_FILTER",
                                       description: "A filter for the target name. Use a standard regex",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :build_configuration,
                                       env_name: "FL_UPDATE_PROVISIONING_NAME_BUILD_CONFIGURATION",
                                       description: "A filter for the build configuration name. Use a standard regex. Applied to all configurations if not specified"),
        ]
      end

      def self.authors
        ["tkohout"]
      end



    end
  end
end
