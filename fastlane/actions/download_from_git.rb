module Fastlane
  module Actions
    module SharedValues
      DOWNLOAD_FROM_GIT_FASTFILE_PATH = :DOWNLOAD_FROM_GIT_FASTFILE_PATH
    end

    class DownloadFromGitAction < Action
      def self.run(params)

        use_cache = params[:use_cache]
        branch = params[:branch]
        url = params[:url]
        path = params[:path]

        # Repo name
        repo_name = url.split("/").last
        
        # To save cached repo
        fastlane_dir = Fastlane::FastlaneFolder.path

        clone_folder = ".shared"


        tmp_path = fastlane_dir + "/" + clone_folder

        
        # Path to fastfile (relative to fastlane directory)
        fastfile_path = clone_folder + "/" + repo_name + "/" + params[:path]

        begin 
          if !use_cache and File.exists? tmp_path 
            Actions.sh("rm -rf '#{tmp_path}'")
          end 

          if !File.exists? tmp_path 
            Dir.mkdir(tmp_path)
            clone_folder = File.join(tmp_path, repo_name)

            branch_option = ""
            branch_option = "--branch #{branch}" if branch != 'HEAD'

            clone_command = "GIT_TERMINAL_PROMPT=0 git clone '#{url}' '#{clone_folder}' --depth 1 -n #{branch_option}"

            UI.message "Cloning remote git repo..."
            Actions.sh(clone_command)

            Actions.sh("cd '#{clone_folder}' && git checkout #{branch} '#{path}'")

            # We also want to check out all the local actions of this fastlane setup
            containing = path.split(File::SEPARATOR)[0..-2]
            containing = "." if containing.count == 0
            actions_folder = File.join(containing, "actions")
            begin
              Actions.sh("cd '#{clone_folder}' && git checkout #{branch} '#{actions_folder}'")
            rescue
              # We don't care about a failure here, as local actions are optional
            end

            UI.success "Download Fastfile to '#{fastfile_path}'"
          else 
            if !File.exists? fastlane_dir + "/" + fastfile_path
              raise "Cached Fastfile not found"
            else 
              UI.success "Loaded cached Fastfile from '#{fastfile_path}'"
            end
          end 
        
        rescue RuntimeError => e
          if (e.message.include? "Cached Fastfile not found")
            # Could not find the 
            use_cache = false
            retry
          else 
            raise
          end  
        end

        Actions.lane_context[SharedValues::DOWNLOAD_FROM_GIT_FASTFILE_PATH] = fastfile_path
        ENV[SharedValues::DOWNLOAD_FROM_GIT_FASTFILE_PATH.to_s] = fastfile_path

        return fastfile_path
          
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :url,
                                       env_name: "FL_DOWNLOAD_FROM_GIT_URL", 
                                       description: "URL for git repo", 
                                       verify_block: proc do |value|
                                          UI.user_error!("No URL for git repo, pass using `url: 'your_url'`") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :branch,
                                       env_name: "FL_DOWNLOAD_FROM_GIT_BRANCH",
                                       description: "Branch in git repo",
                                       default_value: 'HEAD',
                                       optional: true
                                       ), 
          FastlaneCore::ConfigItem.new(key: :path,
                                       env_name: "FL_DOWNLOAD_FROM_GIT_PATH",
                                       description: "Path to Fastfile in repo",
                                       default_value: 'fastlane/Fastfile',
                                       optional: true
                                       ),
          FastlaneCore::ConfigItem.new(key: :use_cache,
                                       env_name: "FL_DOWNLOAD_FROM_GIT_USE_CACHE",
                                       description: "Use cached git repo downloaded last time",
                                       default_value: false,
                                       is_string: false,
                                       optional: true
                                       )
        ] 
      end

      def self.output
        [
          ['DOWNLOAD_FROM_GIT_FASTFILE_PATH', 'A path to the downloaded Fastfile file that you should import in your fastfile (import ENV[SharedValues::DOWNLOAD_FROM_GIT_FASTFILE_PATH])']
        ]
      end

      def self.authors
        ["tkohout"]
      end

      
    end
  end
end
