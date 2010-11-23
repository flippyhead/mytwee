require File.join(File.dirname(__FILE__), '..', 'application.rb')

Bundler.require(:default, :test)

require 'rack/test'
require 'spec/autorun'
require 'spec/interop/test'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

Spec::Runner.configure do |config|
  config.include Helpers
end


###########
# HELPERS
###########

class RedisSpecHelper
  TEST_DB_ID = 14

  def self.reset
    Ohm.redis.select(TEST_DB_ID)
    Ohm.flush
  end
end

module AuthHelper
  def mock_user(attributes = {})
    mock(User, attributes.merge(:id => 1, :screen_name => 'flippyhead'))
  end

  def mock_messages(attributes = {})
    mock(Array, attributes.merge(:sort_by => []))
  end
  
  def login_as(user)
    stub_get('/1/users/show/1.json', 'flippyhead.json')
    stub_get('/1/statuses/friends_timeline.json?count=200&screen_name=flippyhead', 'friends_timeline.json')
    stub_get('/1/statuses/user_timeline.json?count=200&screen_name=flippyhead', 'user_timeline.json')
    authorization = mock(Tweetable::Authorization, :user_id => user.id, :oauth_access_token => 'token', :oauth_access_secret => 'secret')
    Tweetable::Authorization.stub!(:find => [authorization])
  end
end

module FakeWebHelpers  
  # Make sure nothing gets out (IMPORTANT)  
  FakeWeb.allow_net_connect = false  
  
  # Turns a fixture file name into a full path  
  def fixture_file(filename)  
    return '' if filename == ''
    file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)  
    File.read(file_path)
  end  
  
  # Convenience methods for stubbing URLs to fixtures  
  def stub_get(url, filename, options = {})
    fwoptions = {:body => fixture_file(filename)}
    fwoptions.merge!({:status => options[:status]}) unless options[:status].nil?
    FakeWeb.register_uri(:get, twitter_url(url, options[:login], options[:password]), fwoptions)
  end
  
  def stub_post(url, filename)  
    FakeWeb.register_uri(:post, url, :response => fixture_file(filename))  
  end  
  
  def stub_any(url, filename)  
    FakeWeb.register_uri(:any, url, :response => fixture_file(filename))  
  end
  
  def twitter_url(path, login=nil, password=nil)
    if path =~ /^http/
      path
    else
      login || password ? "http://#{login}:#{password}@api.twitter.com#{path}" : "http://api.twitter.com#{path}"
    end    
  end  
end