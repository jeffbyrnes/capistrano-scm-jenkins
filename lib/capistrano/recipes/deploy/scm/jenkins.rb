require 'open-uri'
require 'tmpdir'
require 'rexml/document'

require 'capistrano/recipes/deploy/scm/base'

module Capistrano
  module Deploy
    module SCM
      class Jenkins < Base
        def head
          last_successful_build
        end

        def query_revision(revision)
          return revision if revision =~ /^\d+$/
          raise "invalid revision: #{revision}"
        end

        def checkout(revision, destination)
          %Q{TMPDIR=`mktemp -d`;
            cd "$TMPDIR";
            wget '#{artifact_zip_url(revision)}';
            unzip archive.zip;
            mv archive "#{destination}";
            rm -rf "$TMPDIR"
          }
        end

        alias_method :export, :checkout

        def log(from, to=nil)
          log_build_message(from, to)
          log_scm_message(from, to)
          'true'
        end

        def diff(from, to=nil)
          logger.info 'jenkins does not support diff'
          'true'
        end

        private

        def log_build_message(from, to=nil, message=nil)
          message = rss_all if message.nil?
          doc = REXML::Document.new(message).root
          logger.info ''
          logger.info "BUILD LOG"
          logger.info '========='
          REXML::XPath.each(doc,"./entry") do |entry|
            title = REXML::XPath.first(entry, "./title").text
            time = REXML::XPath.first(entry, "./updated").text
            build_number = get_build_number_from_rss_all_title(title).to_i
            if build_number > from.to_i and (to.nil? or build_number <= to.to_i)
              logger.info "#{time}\t#{title}"
            end
          end
        end

        def log_scm_message(from, to=nil, message=nil)
          message = rss_changelog if message.nil?
          doc = REXML::Document.new(message).root
          logger.info "SCM LOG"
          logger.info '======='
          REXML::XPath.each(doc,"./entry") do |entry|
            title = REXML::XPath.first(entry, "./title").text
            time = REXML::XPath.first(entry, "./updated").text
            content = REXML::XPath.first(entry, "./content").text
            build_number = get_build_number_from_rss_changelog_title(title).to_i
            if build_number > from.to_i and (to.nil? or build_number <= to.to_i)
              logger.info "#{time}\t#{title}"
              logger.info "#{content}"
            end
          end
        end

        def last_successful_build(message = nil)
          message = rss_all if message.nil?
          doc = REXML::Document.new(message).root
          REXML::XPath.each(doc,"./entry/title") do |title|
            title = title.text
            if title.end_with? '(back to normal)' or title.end_with? '(stable)':
              return get_build_number_from_rss_all_title(title)
            end
          end
          raise 'can not find a build suitable for deploy'
        end

        def get_build_number_from_rss_all_title(title)
          /#(\d+) \([^(]+$/.match(title)[1]
        end

        def get_build_number_from_rss_changelog_title(title)
          /^#(\d+) /.match(title)[1]
        end

        def rss_all
          @rss_all ||= open(repository + '/rssAll').read()
        end

        def rss_changelog
          @rss_changelog ||= open(repository + '/rssChangelog').read()
        end

        def artifact_zip_url(revision)
          "#{repository}/#{revision}/artifact/*zip*/archive.zip"
        end
      end
    end
  end
end
