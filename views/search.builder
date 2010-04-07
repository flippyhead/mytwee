xml.tag!('context', :uid => @search.query, :type => @search.class.name) do    
  xml.tag!('messages', :count => @messages.size) do
    @messages.each do |message|      
      xml.tag!('message', :uid => message.message_id) do
        xml.created_at(message.sent_at)
        xml.from_user_id(message.from_user_id)
        xml.from_screen_name(message.from_screen_name)
        xml.text(message.text)
      end
    end
  end
end