require 'spec_helper'
require 'capistrano/recipes/deploy/scm/jenkins'

module Capistrano::Deploy::SCM
  describe Jenkins do
    before :each do
      @jenkins = Jenkins.new
    end

    context "last_deploy_build" do
      it "should support back to normal" do
        msg = %Q{<?xml version="1.0" encoding="UTF-8"?>
  <feed xmlns="http://www.w3.org/2005/Atom"><title>estore-nginx all builds</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/estore-nginx/" rel="alternate"/><updated>2011-11-24T07:11:06Z</updated><author><name>Jenkins Server</name></author><id>urn:uuid:903deee0-7bfa-11db-9fe1-0800200c9a66</id><entry><title>estore-nginx #2 (back to normal)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/estore-nginx/2/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:estore-nginx:2011-11-24_15-11-06</id><published>2011-11-24T07:11:06Z</published><updated>2011-11-24T07:11:06Z</updated></entry><entry><title>estore-nginx #1 (broken for a long time)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/estore-nginx/1/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:estore-nginx:2011-11-24_15-09-18</id><published>2011-11-24T07:09:18Z</published><updated>2011-11-24T07:09:18Z</updated></entry></feed>}
  @jenkins.send(:last_deploy_build, msg).should == '2'
      end

      it "should support stable" do
        msg = %Q{<?xml version="1.0" encoding="UTF-8"?>
  <feed xmlns="http://www.w3.org/2005/Atom"><title>cerl all builds</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/cerl/" rel="alternate"/><updated>2011-11-17T05:17:58Z</updated><author><name>Jenkins Server</name></author><id>urn:uuid:903deee0-7bfa-11db-9fe1-0800200c9a66</id><entry><title>cerl #98 (stable)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/cerl/98/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:cerl:2011-11-17_13-17-58</id><published>2011-11-17T05:17:58Z</published><updated>2011-11-17T05:17:58Z</updated></entry><entry><title>cerl #97 (stable)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/cerl/97/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:cerl:2011-11-12_18-27-58</id><published>2011-11-12T10:27:58Z</published><updated>2011-11-12T10:27:58Z</updated></entry></feed>}
        @jenkins.send(:last_deploy_build, msg).should == '98'
      end

      it "should honor unstable" do
        msg = %Q{<?xml version="1.0" encoding="UTF-8"?>
  <feed xmlns="http://www.w3.org/2005/Atom"><title>IndexCoordinator all builds</title><link type="text/html" href="http://ci.eb.in.sdo.com/job/IndexCoordinator/" rel="alternate"/><updated>2011-11-24T09:22:32Z</updated><author><name>Jenkins Server</name></author><id>urn:uuid:903deee0-7bfa-11db-9fe1-0800200c9a66</id><entry><title>IndexCoordinator #1450 (unstable)</title><link type="text/html" href="http://ci.eb.in.sdo.com/job/IndexCoordinator/1450/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:IndexCoordinator:2011-11-22_19-44-23</id><published>2011-11-22T11:44:23Z</published><updated>2011-11-22T11:44:23Z</updated></entry><entry><title>IndexCoordinator #1449 (back to normal)</title><link type="text/html" href="http://ci.eb.in.sdo.com/job/IndexCoordinator/1449/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:IndexCoordinator:2011-11-22_19-23-22</id><published>2011-11-22T11:23:22Z</published><updated>2011-11-22T11:23:22Z</updated></entry><entry><title>IndexCoordinator #1448 (broken since this build)</title><link type="text/html" href="http://ci.eb.in.sdo.com/job/IndexCoordinator/1448/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:IndexCoordinator:2011-11-22_19-10-50</id><published>2011-11-22T11:10:50Z</published><updated>2011-11-22T11:10:50Z</updated></entry></feed>
        }
        @jenkins.send(:last_deploy_build, msg).should == '1449'
        @jenkins.send(:last_deploy_build, msg, :use_unstable => true).should == '1450'
      end
    end
  end
end
