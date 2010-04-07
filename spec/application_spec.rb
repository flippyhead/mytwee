require File.dirname(__FILE__) + '/spec_helper'

describe "MyTwee.com" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
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