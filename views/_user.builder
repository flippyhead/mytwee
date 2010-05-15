tidbits ||= nil
messages ||= nil

_xml.tag!('user', :uid => user.user_id, :screen_name => user.screen_name, :type => user.class.name) do
  _xml.updated_at user.updated_at
  _xml.profile_image_url user.profile_image_url
  _xml.tag!('friends', :count => user.friends_count)
  _xml.tag!('followers', :count => user.followers_count)
  
  _xml.tag!('tidbits', :count => user.tidbits.size) do
    user.tidbits.each do |tidbit|
      _xml.tag!(tidbit.name, tidbit.value)
    end
  end
  
  unless user.messagez.nil?
    _xml.tag!('messages', :count => user.messagez.size) do
      user.messagez.each do |message|
        partial "message", :locals => {:message => message, :_xml => _xml}
      end
    end
  end
end