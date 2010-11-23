require 'thread'

module Helpers
  
  class DataInvalidError < StandardError; end
  
  def filter_messages(messages, params = {})
    messages.reject! do |m| 
      (m.nil?) ||
      (m.message_id.to_i <= params['since_id'].to_i && params.include?('since_id')) ||
      (Time.parse(m.sent_at).to_i <= (Time.now.to_i - params['since_seconds_ago'].to_i) && params.include?('since_seconds_ago'))
    end
  end

  def extract_meta_counts(messages)
    users = {}
    messages.map{|m| users[m.from_user_id] ||= m.from_user}
    users
  end
  
  def partial(name, options = {})
    item_name = name.to_sym
    counter_name = "#{name}_counter".to_sym
    if collection = options.delete(:collection)
      collection.enum_for(:each_with_index).collect do |item, index|
        partial(name, options.merge(:locals => { item_name => item, counter_name => index + 1 }))
      end.join
    elsif object = options.delete(:object)
      partial name, options.merge(:locals => {item_name => object, counter_name => nil})
    else
      builder "_#{name}".to_sym, options.merge(:layout => false)
    end
  end

  def authorized?    
    if @authorization
      puts "**** AUTHORIZED: #{@authorization.user_id}"
    else
      redirect '/auth' 
    end
  end
  
  def user
    return if @authorization.nil?
    @user ||= User.find(:user_id => @authorization.user_id).first
  end

  def oauth_callback_url
    ENV['RACK_ENV'] == 'production' ? 'http://mytwee.com/auth/complete' : 'http://localhost/auth/complete'
  end
  
  def oauth
    @oauth ||= Twitter::OAuth.new($config[:twitter][:key], $config[:twitter][:secret])
  end
  
  def store_tidbit(user, params)    
    tidbits = user.tidbits.find(:name => params['name']) #Tidbit.find(:name => params['name'], :user_id => user.id)
    @tidbit = tidbits.first unless tidbits.empty?

    if !@tidbit.nil?
      value = params['method'] == 'append' ? @tidbit.value + ",#{params['value']}" : params['value']
      @tidbit.update(:value => value, :updated_at => Time.now.to_s)
    else      
      @tidbit = Tidbit.create(:value => params['value'], :name => params['name'], :updated_at => Time.now.to_s, :user => user)
      # puts "NEW: #{tidbits.inspect} / #{params.inspect} / #{@tidbit.id} / #{user.tidbits.inspect}"
    end

    unless @tidbit.valid?
      raise DataInvalidError.new("Tidbit could not be saved, #{@tidbit.name} / #{@tidbit.user_id}: #{@tidbit.errors.inspect}")
    end        
  end
end 