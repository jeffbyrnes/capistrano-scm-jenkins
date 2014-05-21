namespace :jenkins do

  def strategy
    @strategy ||= Capistrano::Jenkins.new(
      self,
      fetch(:jenkins_strategy, Capistrano::Jenkins::DefaultStrategy))
  end

  desc 'Check that Jenkins is reachable & the last build is green'
  task :check do
    on release_roles :all do
      strategy.check
    end
  end

  desc 'Clone the repo to the cache'
  task clone: :'jenkins:check' do
    on release_roles :all do
      if strategy.test
        info t(:mirror_exists, at: repo_path)
      else
        within deploy_path do
          debug "We're not cloning anything, just creating #{repo_path}"
          strategy.clone
        end
      end
    end
  end

  desc 'Update the repo mirror to reflect the origin state'
  task update: :'jenkins:clone' do
    on release_roles :all do
      within repo_path do
        strategy.update
      end
    end
  end

  desc 'Copy repo to releases'
  task create_release: :'jenkins:update' do
    on release_roles :all do
      within repo_path do
        execute :mkdir, '-p', release_path
        strategy.release
      end
    end
  end

  desc 'Determine the revision that will be deployed'
  task :set_current_revision do
    on release_roles :all do
      within repo_path do
        set :current_revision, strategy.fetch_revision
      end
    end
  end
end
