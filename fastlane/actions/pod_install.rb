module Fastlane
  module Actions
    
    class PodInstallAction < Action
      def self.run(params)
        if other_action.is_ci
          UI.message "Running on CI installing pods with pod repo update"
          sh "pod install --repo-update"
        else
          UI.message "Running locally pod repo update not neccessary"
          sh "pod install"
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Installs pods and if it is on CI updates repo"
      end

      def self.available_options
        [
        ]
      end

      def self.authors
        ["olejnak"]
      end

      def self.output
        [
          
        ]
      end

    end
  end
end
