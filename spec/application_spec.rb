require File.dirname(__FILE__) + '/spec_helper'


describe Sinatra::Application do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  context 'when posting tidbits' do
    it "should store tibits on other users" do
      # controller.stub!(:authorized? => true)
      # Tweetable::Authorization.stub!(:find => mock('Authorization', :first => '12345'))
      # mock_user = mock(User, :tidbits => mock('Tidbits', :find => []))
      # User.should_receive(:find).with(:screen_name => 'flippyhead').and_return([mock_user])
      # post '/user/flippyhead/tidbits'
    end
    
    it "should call store tidbit" do
      # Tweetable::Authorization.stub!(:find => mock('Authorization', :first => '12345'))
      # Sinatra::Application.should_receive(:store_tidbit).and_raise(Exception)
      # post '/user/flippyhead/tidbits'
    end
  end
  
  context "when initiating Twitter authorization" do
    it "should redirect to Twitter" do
      get '/auth'
      last_response.headers["Location"].should =~ /twitter.com\/oauth\/authorize/
    end
    
    it "should include auth token in redirect" do
      get '/auth'
      last_response.headers["Location"].should =~ /\?oauth_token=[a-z0-9]+/i
    end  
  end
    
  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end
end