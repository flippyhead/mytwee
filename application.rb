require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra' # must require this separately for app.rb to load
Bundler.require
require 'lib/helpers'
require 'lib/config'

autoload :User, File.join(File.dirname(__FILE__), *%w[lib user.rb])
autoload :Tidbit, File.join(File.dirname(__FILE__), *%w[lib tidbit.rb])

helpers do
  include Helpers
end

configure do   
  enable :sessions, :lock
  disable :clean_trace, :raise_errors, :dump_errors
end

not_found do
  @message = "The page you requested could not be found."
  builder :not_found
end

configure :production do
  error do  
    content_type 'text/html', :charset => 'utf-8'
    builder :error
  end
end

error OAuth::Unauthorized do 
  @type = "401 Unauthorized"
  @message = "You are not authorized to perform this action."  
  builder :error  
end

error Twitter::Unauthorized do 
  @type = "401 Unauthorized"
  @message = "Twitter could not authenticate you."  
  builder :error  
end

error Twitter::Unavailable do 
  @type = "502 Bad Gateway"
  @message = "Twitter is temporarily unavailable, try again now."
  builder :error
end

error Twitter::NotFound do 
  @type = "404 Not Found"
  @message = "The twitter user requested could not be found."  
  builder :error  
end

error Twitter::InformTwitter do 
  @type = '500 Twitter Internal Error'
  @message = "Twitter has an internal error, please try again in a few minutes."
  builder :error
end

error Twitter::General do
  @type = "Twitter General Error"
  @message = "Twitter generated an general user error."
  builder :error  
end

error Helpers::DataInvalidError do 
  @type = '406 Invalid Content'
  @message = "Data was rejected MyTwee as invalid."
  builder :error
end

before do 
  content_type 'application/xml', :charset => 'utf-8'
  Ohm.connect(:db => 2)
  
  Tweetable.config({
    :max_message_count => 200, 
    :include_on_update => [:info, :messages, :friend_messages],
    :update_delay => 60
  })

  @authorization = Tweetable::Authorization.find(:oauth_access_token => session[:access_token]).first
  Tweetable.authorize($config[:twitter][:key], $config[:twitter][:secret], @authorization)
end

get '/' do
  content_type 'text/html', :charset => 'utf-8'
  @logged_in = (@authorization.nil? ? 0 : 1)
  erb :flash
end

get '/auth' do
  oauth.set_callback_url(oauth_callback_url)
  session[:request_token] = oauth.request_token.token
  session[:request_token_secret] = oauth.request_token.secret
  redirect oauth.request_token.authorize_url
end

get '/deauth' do
  @authorization.delete
  session[:request_token] = nil
  session[:request_token_secret] = nil
end

get '/auth/complete' do
  oauth.authorize_from_request(session[:request_token], session[:request_token_secret], params[:oauth_verifier])  
  @authorization = Tweetable::Authorization.find_or_create(:oauth_access_token, oauth.access_token.token)
  @authorization.update(:oauth_access_secret => oauth.access_token.secret)
  session[:access_token] = @authorization.oauth_access_token
  
  redirect "/"
end

get "/status" do
  @status = Tweetable.client.status    
  builder :status
end

post "/status" do
  authorized?
  Tweetable::Message.create_from_status(params[:text], @authorization.client)
  
  @message = "Status text successfully sent!"  
  builder :success
end

post "/tidbits" do
  authorized?
  store_tidbit(user, params)
  builder :tidbit
end

get "/leaders" do
  authorized?
  @monthly_tidbits = Tidbit.search(:name => 'badgepoints', :ago => 30*24*60*60).to_a
  @alltime_tidbits = Tidbit.search(:name => 'badgepoints').to_a
  @recent_tidbits  = Tidbit.search(:name => 'badgepoints').to_a.sort{|a,b| Time.parse(a.updated_at) <=> Time.parse(b.updated_at)}.reverse
  
  builder :leaders
end

get "/user" do
  authorized?

  @user = User.find_or_create(:user_id, @authorization.user_id)
  @user.update_all
  
  @messages = @user.messages.sort_by(:message_id, :limit => 200, :order => 'DESC')  
  @friend_messages = @user.friend_messages.sort_by(:message_id, :limit => 200, :order => 'DESC')
  @messages += @friend_messages  
  
  @messages.compact!
  @messages.sort! unless @messages.nil?
  @messages.uniq! unless @messages.nil?
  
  filter_messages(@messages, params)
    
  @user.messagez = @messages
  
  builder :user  
end

get '/user/latest' do
  authorized?
  @user = User.find(:user_id, @authorization.user_id).first
  @friend_messages = @user.friend_messages.sort_by(:message_id, :limit => 200, :order => 'DESC')
  filter_messages(@friend_messages, params)
  @users = extract_meta_counts(@friend_messages).values
  builder :latest
end

get "/user/:screen_name" do    
  @user = User.find_or_create(:screen_name, params[:screen_name].downcase)
  
  @user.update_info
  @user.update_messages  
  
  @messages = @user.messages.sort_by(:message_id, :limit => 200, :order => 'DESC')
  @friend_messages = @user.friend_messages.sort_by(:message_id, :limit => 200, :order => 'DESC')
  @messages = @messages + @friend_messages    
  
  filter_messages(@messages, params)
  
  @messages.compact!
  @messages.sort! unless @messages.nil?  
  
  @user.messagez = @messages
  
  builder :user
end

post "/user/:screen_name/tidbits" do
  authorized?

  other_user = User.find(:screen_name => params[:screen_name].downcase).first
  store_tidbit(other_user, params)
  
  builder :tidbit
end

get '/search/:query' do
  @search = Tweetable::Search.find_or_create(:query, params[:query])  
  @search.update_all
  @messages = @search.messages.sort_by(:message_id, :limit => 400, :order => 'DESC')
  @messages.sort! unless @messages.nil?
  filter_messages(@messages, params)
  builder :search
end