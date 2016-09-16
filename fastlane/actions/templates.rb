module Fastlane
  module Actions
    class TemplatesAction < Action
      def self.run(params)
        
        #Location of iPhone Templates for reference
        #/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/File Templates/

        install_dir = File.expand_path("~/Library/Developer/Xcode/Templates/File Templates")
        
        if ! File.exists? install_dir
          UI.message "Creating File Template Xcode directory #{install_dir}"
          FileUtils.mkdir_p install_dir
        end

        src_dir = File.expand_path(params[:source_dir], Fastlane::FastlaneFolder.path)
        template_folders = Dir.entries(src_dir)

        template_folders.each do |template_folder|
          template_folder_path = "#{src_dir}/#{template_folder}"

          if File.directory?(template_folder_path) 

            xctemplates = Dir.entries(template_folder_path).select{ |e| File.extname(e) == ".xctemplate"  }
            
            install_folder_path = "#{install_dir}/#{template_folder}/"
            FileUtils.mkdir_p install_folder_path

            xctemplates.each do |xctemplate|
              src_template_path = "#{template_folder_path}/#{xctemplate}"
              
              if File.exists? "#{install_folder_path}/#{xctemplate}"
                UI.message "Removing template #{xctemplate}"
                FileUtils.rm_rf "#{install_folder_path}/#{xctemplate}"
              end

              UI.message "Installing template #{xctemplate} in folder #{install_folder_path}"
              FileUtils.cp_r src_template_path, install_folder_path
            end

          end 
        end
        return true
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Installs templates to xcode"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :source_dir,
                                       env_name: "FL_TEMPLATES_SOURCE_DIR", # The name of the environment variable
                                       description: "Source dir for the templates", # a short description of this parameter
                                       optional: true,
                                       default_value: "userdata/FileTemplates"
                                       )
        ]
      end

    end
  end
end
