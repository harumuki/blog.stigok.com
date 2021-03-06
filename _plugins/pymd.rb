require 'open3'

module Jekyll
  module Pymd

    class Generator < Jekyll::Generator
      def generate(site)
        return if ARGV.include?("--no-pymd")

        @site = site
        site.posts.docs.each do |post|
          # Only run if pymd is explicitly specified
          next unless post.data.has_key?('processors')
          next unless post.data['processors'].include?('pymd')

          puts "pymd: processing \"#{post.data['title']}\""
          stdout, stderr, res = Open3.capture3("/usr/bin/python3 #{__dir__}/pymd.py -", :stdin_data=>post.content)

          stderr.to_s.each_line do |line|
            puts "pymd: #{line}"
          end

          if res != 0 then
            raise "pymd failed: #{res}"
            Process.exit 1
          end

          post.content = stdout
          post
        end
      end
    end

  end
end
