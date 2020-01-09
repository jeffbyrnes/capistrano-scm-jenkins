# frozen_string_literal: true

require 'capistrano/scm/plugin'

# Jenkins SCM Plugin for Capistrano
#
# @author Jeff Byrnes <thejeffbyrnes@gmail.com>
#
class Capistrano::SCM::Jenkins < ::Capistrano::SCM::Plugin
  def set_defaults
    set_if_empty :jenkins_user, 'jenkins'
    set_if_empty :jenkins_pass, nil
    set_if_empty :jenkins_build_number, 'lastBuild'
    set_if_empty :jenkins_use_unstable, false
    set_if_empty :jenkins_insecure, false
    set_if_empty :allowed_statuses, lambda {
      statuses = %w[success]

      statuses << 'unstable' if fetch(:jenkins_use_unstable)

      statuses
    }
  end

  def register_hooks
    after 'deploy:new_release_path', 'jenkins:create_release'
    before 'deploy:check', 'jenkins:check'
    before 'deploy:set_current_revision', 'jenkins:set_current_revision'
  end

  def define_tasks
    eval_rakefile File.expand_path('tasks/jenkins.rake', __dir__)
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

  def artifact_build_number
    @artifact_build_number ||= jenkins_api_res['number']
  end

  def artifact_url
    "#{repo_url}/#{fetch(:jenkins_build_number)}/artifact/#{artifact_file_opt}"
  end

  def jenkins_api_res
    jenkins_job_api_url = "#{repo_url}/#{fetch(:jenkins_build_number)}/api/json"

    uri = URI.parse(jenkins_job_api_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.basic_auth(jenkins_user, jenkins_pass) if jenkins_user && jenkins_pass
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if fetch(:jenkins_insecure)

    @jenkins_api_res = JSON.parse(http.get(uri.request_uri).body)
  # README: Courtesy of https://stackoverflow.com/a/5370726/133479
  rescue Timeout::Error,
         Errno::EINVAL,
         Errno::ECONNRESET,
         EOFError,
         Net::HTTPBadResponse,
         Net::HTTPHeaderSyntaxError,
         Net::ProtocolError => e
    abort "Request to '#{jenkins_job_api_url}'} failed: #{e}"
  end

  def check_latest_build
    res          = jenkins_api_res
    build_status = res['result'].downcase

    if allowed_statuses.include? build_status
      if artifact_is_zip?
        abort 'unzip required, but not found' unless backend.test 'hash unzip 2>/dev/null'
      end

      true
    else
      abort "Latest build status isn't green!"
    end
  end

  def download_artifact
    # grab the newest artifact
    backend.execute :curl, "--silent --fail --show-error #{curl_auth} " \
      "#{artifact_url} -o #{fetch(:deployed_artifact_filename, artifact_filename)} " \
      "#{'--insecure' if fetch(:jenkins_insecure)}"
  end

  def archive_to_release_path
    if artifact_is_zip?
      # is an archive - unpack and deploy
      backend.execute :rm, '-rf', 'out'
      backend.execute :unzip, fetch(:deployed_artifact_filename, artifact_filename), '-d', 'out/'
      backend.execute :bash, "-c 'shopt -s dotglob; mv out/#{fetch(:jenkins_artifact_path, '*')} #{release_path}'"
      backend.execute :rm, '-rf', 'out'
    else
      backend.execute :cp, fetch(:deployed_artifact_filename, artifact_filename), release_path
    end
  end

  def fetch_revision
    "build-#{artifact_build_number}"
  end
end
