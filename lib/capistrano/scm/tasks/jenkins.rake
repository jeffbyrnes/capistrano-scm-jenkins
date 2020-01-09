# frozen_string_literal: true

# This trick lets us access the Jenkins plugin within `on` blocks.
jenkins_plugin = self

namespace :jenkins do
  desc 'Check that Jenkins is reachable & the last build is green'
  task :check do
    on release_roles :all do
      jenkins_plugin.check_latest_build
    end
  end

  desc 'setup the containing directory'
  task setup: :'jenkins:check' do
    on release_roles :all do
      within deploy_path do
        execute :mkdir, '-p', repo_path
      end
    end
  end

  desc 'Download the build artifact'
  task download_artifact: :'jenkins:setup' do
    on release_roles :all do
      within repo_path do
        jenkins_plugin.download_artifact
      end
    end
  end

  desc 'Unpack the artifact'
  task create_release: :'jenkins:download_artifact' do
    on release_roles :all do
      within repo_path do
        execute :mkdir, '-p', release_path
        jenkins_plugin.archive_to_release_path
      end
    end
  end

  desc 'Determine the revision that will be deployed'
  task :set_current_revision do
    on release_roles :all do
      within repo_path do
        set :current_revision, jenkins_plugin.fetch_revision
      end
    end
  end
end
