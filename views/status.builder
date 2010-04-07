xml.tag!('status') do
  unless @authorization.nil?
    xml.authorization_id @authorization.id
    xml.authorization_token "#{@authorization.oauth_access_token[0..15]}..."
  end
  xml.hourly_limit @status[:hourly_limit]
  xml.remaining_hits @status[:remaining_hits]
  xml.reset_time @status[:reset_time]
end