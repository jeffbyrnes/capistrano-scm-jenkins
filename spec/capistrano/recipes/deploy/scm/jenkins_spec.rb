require 'spec_helper'
require 'capistrano/recipes/deploy/scm/jenkins'

module Capistrano::Deploy::SCM
  describe Jenkins do
    before :each do
      @jenkins = Jenkins.new
    end

    context "last_successful_build" do
      it "should support back to normal" do
        msg = %Q{<?xml version="1.0" encoding="UTF-8"?>
  <feed xmlns="http://www.w3.org/2005/Atom"><title>estore-nginx all builds</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/estore-nginx/" rel="alternate"/><updated>2011-11-24T07:11:06Z</updated><author><name>Jenkins Server</name></author><id>urn:uuid:903deee0-7bfa-11db-9fe1-0800200c9a66</id><entry><title>estore-nginx #2 (back to normal)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/estore-nginx/2/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:estore-nginx:2011-11-24_15-11-06</id><published>2011-11-24T07:11:06Z</published><updated>2011-11-24T07:11:06Z</updated></entry><entry><title>estore-nginx #1 (broken for a long time)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/estore-nginx/1/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:estore-nginx:2011-11-24_15-09-18</id><published>2011-11-24T07:09:18Z</published><updated>2011-11-24T07:09:18Z</updated></entry></feed>}
  @jenkins.send(:last_successful_build, msg).should == '2'
      end
    end
  end
end
