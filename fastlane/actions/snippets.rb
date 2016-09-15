module Fastlane
  module Actions
    module SharedValues
    end

    class SnippetsAction < Action
      def self.run(params)

        repo = params[:git_repo] 
        FileUtils.rm_rf "/tmp/snippets"      
        install_dir = File.expand_path("~/Library/Developer/Xcode/UserData/CodeSnippets")
        if ! File.exists? install_dir
            UI.message "Creating Code Snippets Xcode directory #{install_dir}"
            FileUtils.mkdir_p install_dir
        end
        sh "git clone #{repo} /tmp/snippets"
        src_dir = File.expand_path("/tmp/snippets/snippets/")
        code_snippets =  Dir.entries(src_dir).select{ |e| File.extname(e) == ".codesnippet"  }
        code_snippets.select.each do |snippet|
          src_snippet_path = "#{src_dir}/#{snippet}"

          UI.message "Installing code snippet #{snippet}"
          FileUtils.cp_r src_snippet_path, install_dir
        end
        
        UI.success "Successfully installed #{code_snippets.count} snippets into Xcode"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Installs snippets from repository to Xcode"
      end


      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :git_repo,
                                       env_name: "FL_SNIPPETS_GIT_REPO",
                                       description: "URL of the snippet git repository", 
                                       verify_block: proc do |value|
                                          UI.user_error!("No git repo for snippet given, pass using `git_repo: 'repo'`") unless (value and not value.empty?)
                                       end)
        ]
      end

      def self.output
        [
          
        ]
      end

      def self.authors
        ["tkohout"]
      end

    end
  end
end
