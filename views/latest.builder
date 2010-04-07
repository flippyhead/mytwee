xml.tag!('user', :uid => @user.user_id, :screen_name => @user.screen_name, :type => @user.class.name) do    
  xml.tag!('friends', :count => @user.friends_count)
  xml.tag!('followers', :count => @user.followers_count)
  xml.tag!('latest', :count => @users.size) do
    @users.each do |user|      
      xml.tag!('user', :uid => user.user_id, :screen_name => user.screen_name, :type => user.class.name) do    
        xml.tag!('friends', :count => user.friends_count)
        xml.tag!('followers', :count => user.followers_count)
      end      
    end
  end
end