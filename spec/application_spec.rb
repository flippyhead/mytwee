require File.dirname(__FILE__) + '/spec_helper'


describe Sinatra::Application do
  include Rack::Test::Methods
  include AuthHelper
  include FakeWebHelpers
  
  def app
    Sinatra::Application
  end
  
  before do    
    @messages = mock_messages

    @user = mock_user(:updated_at => Date.new,
      :update_friend_messages => true, 
      :messages => @messages, 
      :friend_messages => @messages, 
      :profile_image_url => 'http://image.url',
      :friends_count => 1,
      :followers_count => 1,
      :tidbits => [],
      :user_id => 1)
      
    login_as(@user)
  end    
  
  context 'when getting user home' do
    it 'should ' do
      @user.stub!(:update_all => true, :messagez= => true, :messagez => [])
      User.stub!(:find_or_create => @user)
      app.stub!(:builder => {})
      get '/user'
    end
  end
  
  context 'when posting tidbits' do
    it "should store tibits on other users" do      
      # @user.should_receive(:tidbits).and_return([])
      # post '/user/flippyhead/tidbits'
    end
    
    it "should call store tidbit" do
      # app.should_receive(:store_tidbit).and_raise(Exception)
      # post '/user/flippyhead/tidbits'
    end
  end

  context 'when listing leaders' do
    it 'should get leaders list' do
      get '/leaders'
      last_response.headers["Location"].should be_nil # success
    end
    
    it 'should assign recent leaders' do
      get '/leaders'
      last_response.body.should include('recent')
    end    
  end
  
  context "when initiating Twitter authorization" do
    # it "should redirect to Twitter" do
    #   get '/auth'
    #   last_response.headers["Location"].should =~ /twitter.com\/oauth\/authorize/
    # end
    # 
    # it "should include auth token in redirect" do
    #   get '/auth'
    #   last_response.headers["Location"].should =~ /\?oauth_token=[a-z0-9]+/i
    # end  
  end
    
  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end
end