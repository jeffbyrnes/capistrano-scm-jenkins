load File.expand_path('../tasks/jenkins.rake', __FILE__)

require 'capistrano/scm'
require 'open-uri'
require 'json'

# Jenkins as SCM for Capistrano
#
# @author Jeff Byrnes <jeff@evertrue.com>
#
class Capistrano::Jenkins < Capistrano::SCM
  def jenkins_user
    @jenkins_user ||= begin
      if fetch(:jenkins_user)
        fetch(:jenkins_user)
      else
        nil
      end
    end
  end

  def jenkins_pass
    @jenkins_pass ||= begin
      if fetch(:jenkins_pass)
        fetch(:jenkins_pass)
      else
        nil
      end
    end
  end

  def allowed_statuses
    statuses = %w(success)

    @allowed_statuses ||= begin
      statuses << 'unstable' if fetch(:jenkins_use_unstable)

      statuses
    end
  end

  def ssl_opts
    if fetch(:jenkins_insecure)
      { ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE }
    else
      { ssl_verify_mode: OpenSSL::SSL::VERIFY_PEER }
    end
  end

  def auth_opts
    if jenkins_user && jenkins_pass
      { http_basic_authentication: [jenkins_user, jenkins_pass] }
    else
      {}
    end
  end

  def curl_auth
    if jenkins_user && jenkins_pass
      "--user '#{jenkins_user}:#{jenkins_pass}'"
    else
      ''
    end
  end

  def artifact_is_archive?
    fetch(:jenkins_artifact_file).nil?
  end

  def artifact_file_opt
    fetch(:jenkins_artifact_file, "*zip*/archive.zip")
  end

  def artifact_filename
    @artifact_filename = File.basename(artifact_file_opt)
  end

  def artifact_ext
    @artifact_ext = File.extname(artifact_filename)
  end

  def artifact_url
    "#{repo_url}/lastBuild/artifact/#{artifact_file_opt}"
  end

  def last_build_number
    @last_build_number = jenkins_api_res['number']
  end

  def jenkins_api_res
    jenkins_job_api_url = "#{repo_url}/lastBuild/api/json"

    res ||= open(jenkins_job_api_url, auth_opts.merge(ssl_opts)).read

    @jenkins_api_res = JSON.parse(res)
  rescue => e
    abort "Request to '#{jenkins_job_api_url}'} failed: #{e}"
  end

  # The Capistrano default strategy for git. You should want to use this.
  module DefaultStrategy
    def test
      test! " [ -d #{repo_path} ] "
    end

    def check
      res          = jenkins_api_res
      build_status = res['result'].downcase

      if allowed_statuses.include? build_status
        if artifact_is_archive?
          unless test! "hash unzip 2>/dev/null"
            abort 'unzip required, but not found'
          end
        end

        true
      else
        abort 'Latest build status isn\'t green!'
      end
    end

    def clone
      # Left unimplemented, as Jenkins has no analog to `git clone`
      context.execute :mkdir, '-p', repo_path

      true
    end

    def update
      # grab the newest artifact
      context.execute :curl, "--silent --fail --show-error #{curl_auth} " +
        "#{artifact_url} -o #{fetch(:application)}#{artifact_ext} " +
        "#{"--insecure" if fetch(:jenkins_insecure)}"
    end

    def release
      downloaded_artifact = "#{fetch(:application)}#{artifact_ext}"

      if artifact_is_archive?
        # is an archive - unpack and deploy
        context.execute :rm, "-rf \"out/\""
        context.execute :unzip, "\"#{downloaded_artifact}\" -d out/"
        context.execute :mv, "out/#{fetch(:jenkins_artifact_path, "*")} \"#{release_path}\""
        context.execute :rm, "-rf \"out/\""
      else
        context.execute :cp, "\"#{downloaded_artifact}\" \"#{release_path}\""
      end
    end

    def fetch_revision
      "build-#{last_build_number}"
    end
  end
end
