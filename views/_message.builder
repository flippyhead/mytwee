return if message.nil?
_xml.tag!('message', :uid => message.message_id, :id => message.id) do
  _xml.created_at(message.sent_at)
  _xml.from_screen_name(message.from_screen_name)
  _xml.from_user_id(message.from_user_id)        
  _xml.text(message.text)
end
