require 'open-uri'
require 'rexml/document'

require 'capistrano/recipes/deploy/scm/base'

module Capistrano
  module Deploy
    module SCM
      class Jenkins < Base
        def head
          'lastSuccessfulBuild'
        end

        def query_revision(revision)
          return revision if revision =~ /^\d+$/
          return last_successful_build if revision == head
          raise "invalid revision: #{revision}"
        end

        def checkout(revision, destination)
          puts repository
          #scm :checkout, arguments, arguments(:checkout), verbose, authentication, "-r#{revision}", repository, destination
        end

        private
        def last_successful_build(message = nil)
          message = rss_all if message.nil?
          doc = REXML::Document.new(message).root
          REXML::XPath.each(doc,"./entry/title") do |title|
            title = title.text
            if title.end_with? '(back to normal)' or title.end_with? '(stable)':
              return /#(\d+) \([^(]+$/.match(title)[1]
            end
          end
        end

        def rss_all
          open(repository + '/rssAll').read()
        end
      end
    end
  end
end
