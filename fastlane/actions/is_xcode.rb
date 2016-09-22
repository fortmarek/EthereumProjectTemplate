module Fastlane
  module Actions
    class IsXcodeAction < Action
      def self.run(params)
        return ENV['XCODE_VERSION_ACTUAL'] != nil
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Returns whether fastlane is run by a xcode run script phase"
      end

      def self.authors
        ["tkohout"]
      end
    end
  end
end
