xml.tag!('context', :uid => @context.uid, :type => @context.class.name) do    
  xml.tag!('friends', :count => @context.friends.size) do
    xml.uids(@context.friends.to_a.join(', '))
  end
end