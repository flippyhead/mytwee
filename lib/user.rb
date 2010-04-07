class User < Tweetable::User
  attribute :created_at
  attribute :updated_at    
  attribute :screen_name
  attribute :profile_image_url
  attribute :user_id
  attribute :friends_count
  attribute :followers_count
  
  index :screen_name
  index :user_id

  list :messages, Tweetable::Message
  list :friend_messages, Tweetable::Message

  set :friend_ids
  set :follower_ids
  set :tags
  
  collection :tidbits, Tidbit
  
  attr_accessor :messagez    
  
  def self.setup(user_id)    
    user = find_or_create(:user_id, user_id)
    
    user.update_all
    user.update_friend_messages

    messages = user.messages.sort_by(:message_id, :limit => 200, :order => 'DESC')
    friend_messages = user.friend_messages.sort_by(:message_id, :limit => 200, :order => 'DESC')
    messages = messages + friend_messages  

    messages.compact!
    messages.sort! unless messages.nil?

    filter_messages(messages, params)

    user.messagez = messages
  end
  
  def self.filter_messages(messages, params = {})
    # 2_weeks_ago = Time.now - (60 * 60 * 24 * 14)
    messages.reject! do |m| 
      (m.nil?) ||
      (m.message_id.to_i <= params['since_id'].to_i && params.include?('since_id')) ||
      (Time.parse(m.sent_at).to_i <= (Time.now.to_i - params['since_seconds_ago'].to_i) && params.include?('since_seconds_ago'))
    end
  end  
end