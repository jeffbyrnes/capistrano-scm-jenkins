require 'spec_helper'

require 'capistrano/jenkins'

module Capistrano
  describe Jenkins do
    let(:context) { Class.new.new }
    subject { Capistrano::Jenkins.new(context, Capistrano::Jenkins::DefaultStrategy) }

    # TODO Add tests for individual methods
  end

  describe Jenkins::DefaultStrategy do
    let(:context) { Class.new.new }
    subject { Capistrano::Jenkins.new(context, Capistrano::Jenkins::DefaultStrategy) }

    describe '#test' do
      it 'should call test for repo_path' do
        context.expects(:repo_path).returns('/path/to/repo')
        context.expects(:test).with " [ -d /path/to/repo/ ] "

        subject.test
      end
    end

    # describe '#check' do
    #   it 'should check the build status' do
    #     # Mock out the return of `jenkins_api_res()`
    #     context.expects(:build_status).returns('success')

    #     subject.check
    #   end
    # end

    describe '#clone' do
      it 'should create the repo_path folder' do
        context.expects(:repo_path).returns(:path)

        context.expects(:execute).with(:mkdir, '-p', :path)

        subject.clone
      end
    end

    describe '#update' do
      it 'should grab the newest artifact' do
        context.expects(:fetch).returns(:jenkins_user)
        context.expects(:fetch).returns(:jenkins_pass)
        context.expects(:curl_auth).returns('')
        context.expects(:artifact_url).returns('http://jenkins.example.com/lastBuild/artifact/app/target/app-SNAPSHOT.war')
        context.expects(:fetch).returns(:application)
        context.expects(:artifact_ext).returns('.war')

        context.expects(:execute).with(
          :curl,
          '--silent --fail --show-error  ' +
            'http://jenkins.example.com/lastBuild/artifact/app/target/app-SNAPSHOT.war' +
            '-o :application.war'
        )

        subject.update
      end
    end

    describe '#release' do
      it 'should run jenkins archive' do
        context.expects(:fetch).returns(:application)
        context.expects(:release_path).returns(:path)

        context.expects(:execute).with(:cp, :application, :path)

        subject.release
      end
    end
  end
end
