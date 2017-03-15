module Fastlane
  module Actions
    class GeneratePreprocessHeaderAction < Action
      def self.run(params)
        values = params[:values]
        file = File.expand_path(params[:preprocess_file], FastlaneCore::FastlaneFolder.path)

        File.open(file, 'w') do |file|
            values.each do |key, value|
                # if value.is_a? Integer then
                    file.write("#define #{key} #{value}\n")
                # elsif value.is_a? String then
                #     file.write("#define #{key} \"#{value}\"")
                # end
            end
        end

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Generates preprocess header for Info plist from given dictionary"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :values,
                                       description: "Dictionary of values that will be written",
                                       is_string: false
                                       ),
          FastlaneCore::ConfigItem.new(key: :preprocess_file,
                                       env_name: "ACK_PREPROCESS_HEADER",
                                       description: "File where will the data be written",
                                       verify_block: proc do |value|
                                          UI.user_error!("No file given, pass using `preprocess_file: 'preprocess_file'`") unless (value and not value.empty?)
                                       end)
        ]
      end

      def self.authors
        ["olejnjak"]
      end
    end
  end
end
