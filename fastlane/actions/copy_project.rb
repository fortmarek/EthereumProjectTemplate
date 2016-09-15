module Fastlane
  module Actions
    module SharedValues
    end

    class CopyProjectAction < Action
      def self.run(params)

        new_project_name = params[:project_name]
        project_path = params[:destination_path]

        current_project_file = Dir["*.xcodeproj"]
        if current_project_file.count == 0
          raise ".xcodeproj file not found"
        end 

        current_project_name = File.basename( current_project_file[0], ".*" )
        UI.message "Current project name: #{current_project_name}"
        #project_path = File.expand_path(project_path, main_dir)

        if !File.exists? project_path
          FileUtils.mkdir_p project_path
          UI.success("Created new project directory #{project_path}")
        else
          UI.success("Using project directory #{project_path}")
        end

        # Copy & clean
        sh "rsync -r . '#{project_path}' && cd #{project_path} && git clean -xdf"
        UI.success("Copied contents of project to the destination path")

        # Files to change comments in
        source_file_types = [".swift", ".h", ".m"]

        #Change comments in files
        change_project_name_recursively("#{project_path}/Source/", source_file_types, current_project_name, new_project_name)
        change_project_name_recursively("#{project_path}/Tests/", source_file_types, current_project_name, new_project_name)
        UI.success("Changed project name in source file comments")

        #Change project file and rename it
        change_project_name_recursively("#{project_path}/#{current_project_name}.xcodeproj", [".pbxproj", ".xcscheme"], "SampleTestingProject", new_project_name)
        sh "mv '#{project_path}/#{current_project_name}.xcodeproj' '#{project_path}/#{new_project_name}.xcodeproj'"
        UI.success("Changed name of the project file")

        #Remove workspace
        sh "rm -rf '#{project_path}/#{current_project_name}.xcworkspace'"

        #Change project name in podfile
        change_project_name_recursively("#{project_path}/Podfile", nil, current_project_name, new_project_name)
        UI.success("Changed Podfile")
        sh "rm '#{project_path}/Podfile.lock'"

        #Install pods
        sh "cd #{project_path} && pod install"
        UI.success("Installed pods")

        #Remove old git
        sh "rm -rf '#{project_path}/.git/'"
        UI.success("Removed old git history")

        git_repo = params[:git_repo]

        if git_repo
          #Set new git origin
          sh "cd #{project_path} && git init && git add . && git remote add origin '#{git_repo}'"
          UI.success("Set git remote to '#{git_repo}'")
        end

        UI.success("Successfully created '#{new_project_name}' at '#{project_path}'")
      end

      def self.change_project_name_recursively (path, file_types, replace_from, replace_to)
            
          if File.directory? path
            file_names = (Dir.entries(path) - %w{ . ..})
          else
            file_names = [path]
          end

          file_names.each do |file_name|
            
            if file_name != path 
              file_name = File.expand_path(file_name, path)
            end
            UI.message  "#{file_name}" 
            if !file_types || file_types.include?(File.extname(file_name)) 

              text = File.read(file_name)
              new_contents = text.gsub(/#{replace_from}/, replace_to)

              File.open(file_name, "w") {|file| file.puts new_contents }
            elsif File.directory? file_name
              change_project_name_recursively(file_name, file_types, replace_from, replace_to)
            end
        end
      end

    

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Copies current project to a destination and changes its name and git repository"
      end


      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :project_name,
                                       env_name: "FL_COPY_PROJECT_NEW_PROJECT_NAME", 
                                       description: "New project name",
                                       verify_block: proc do |value|
                                          UI.user_error!("No new project name given, pass using `project_name: 'name'`") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :destination_path,
                                       env_name: "FL_COPY_PROJECT_NEW_PROJECT_PATH",
                                       description: "Path to destination", 
                                       verify_block: proc do |value|
                                          UI.user_error!("No destination path given, pass using `destination_path: 'name'`") unless (value and not value.empty?)
                                          if File.exists? value
                                            if !File.directory?(value)
                                              UI.user_error!("Entered path is not a directory") 
                                            elsif !(Dir.entries(value) - %w{ . .. .git .DS_Store }).empty?
                                              UI.user_error!("The directory is not empty") 
                                            end
                                          end
                                        end),
          FastlaneCore::ConfigItem.new(key: :git_repo,
                                       env_name: "FL_COPY_PROJECT_GIT_REPO",
                                       description: "URL of the git repository", 
                                       optional: true)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
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
