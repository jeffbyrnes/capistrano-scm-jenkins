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

  def artifact_is_zip?
    artifact_ext == '.zip'
  end

  def artifact_file_opt
    fetch(:jenkins_artifact_file, '*zip*/archive.zip')
  end

  def artifact_filename
    @artifact_filename = File.basename(artifact_file_opt)
  end

  def artifact_ext
    @artifact_ext = File.extname(artifact_filename)
  end

  def artifact_build_number_opt
    fetch(:jenkins_build_number, 'lastSuccessfulBuild')
  end

  def artifact_build_number
    @artifact_build_number ||= jenkins_api_res['number']
  end

  def artifact_url
    "#{repo_url}/#{artifact_build_number_opt}/artifact/#{artifact_file_opt}"
  end

  def jenkins_api_res
    jenkins_job_api_url = "#{repo_url}/#{artifact_build_number_opt}/api/json"

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
        if artifact_is_zip?
          unless test! 'hash unzip 2>/dev/null'
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
      context.execute :curl, "--silent --fail --show-error #{curl_auth} " \
        "#{artifact_url} -o #{fetch(:deployed_artifact_filename, artifact_filename)} " \
        "#{'--insecure' if fetch(:jenkins_insecure)}"
    end

    def release
      if artifact_is_zip?
        # is an archive - unpack and deploy
        context.execute :rm, '-rf', 'out'
        context.execute :unzip, fetch(:deployed_artifact_filename, artifact_filename), '-d', 'out/'
        context.execute :mv, "out/#{fetch(:jenkins_artifact_path, '*')}", release_path
        context.execute :rm, '-rf', 'out'
      else
        context.execute :cp, fetch(:deployed_artifact_filename, artifact_filename), release_path
      end
    end

    def fetch_revision
      "build-#{artifact_build_number}"
    end
  end
end
