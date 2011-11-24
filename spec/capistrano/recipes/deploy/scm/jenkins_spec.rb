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

      it "should support stable" do
        msg = %Q{<?xml version="1.0" encoding="UTF-8"?>
  <feed xmlns="http://www.w3.org/2005/Atom"><title>cerl all builds</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/cerl/" rel="alternate"/><updated>2011-11-17T05:17:58Z</updated><author><name>Jenkins Server</name></author><id>urn:uuid:903deee0-7bfa-11db-9fe1-0800200c9a66</id><entry><title>cerl #98 (stable)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/cerl/98/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:cerl:2011-11-17_13-17-58</id><published>2011-11-17T05:17:58Z</published><updated>2011-11-17T05:17:58Z</updated></entry><entry><title>cerl #97 (stable)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/cerl/97/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:cerl:2011-11-12_18-27-58</id><published>2011-11-12T10:27:58Z</published><updated>2011-11-12T10:27:58Z</updated></entry><entry><title>cerl #96 (stable)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/cerl/96/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:cerl:2011-11-03_14-39-58</id><published>2011-11-03T06:39:58Z</published><updated>2011-11-03T06:39:58Z</updated></entry><entry><title>cerl #95 (stable)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/cerl/95/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:cerl:2011-10-12_17-21-59</id><published>2011-10-12T09:21:59Z</published><updated>2011-10-12T09:21:59Z</updated></entry><entry><title>cerl #94 (back to normal)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/cerl/94/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:cerl:2011-09-19_16-30-13</id><published>2011-09-19T08:30:13Z</published><updated>2011-09-19T08:30:13Z</updated></entry><entry><title>cerl #93 (broken since build #87)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/cerl/93/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:cerl:2011-09-19_16-28-39</id><published>2011-09-19T08:28:39Z</published><updated>2011-09-19T08:28:39Z</updated></entry><entry><title>cerl #87 (broken since this build)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/cerl/87/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:cerl:2011-08-07_22-39-04</id><published>2011-08-07T14:39:04Z</published><updated>2011-08-07T14:39:04Z</updated></entry><entry><title>cerl #86 (stable)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/cerl/86/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:cerl:2011-06-16_14-10-27</id><published>2011-06-16T06:10:27Z</published><updated>2011-06-16T06:10:27Z</updated></entry><entry><title>cerl #85 (stable)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/cerl/85/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:cerl:2011-04-12_17-43-21</id><published>2011-04-12T09:43:21Z</published><updated>2011-04-12T09:43:21Z</updated></entry><entry><title>cerl #84 (stable)</title><link type="text/html" href="http://ci.eb.in.sdo.com/view/eStore/job/cerl/84/" rel="alternate"/><id>tag:hudson.dev.java.net,2011:cerl:2011-01-18_10-17-37</id><published>2011-01-18T02:17:37Z</published><updated>2011-01-18T02:17:37Z</updated></entry></feed>}
        @jenkins.send(:last_successful_build, msg).should == '98'
      end
    end
  end
end
