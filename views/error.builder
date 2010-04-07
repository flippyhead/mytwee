xml.tag!('error') do
  xml.message (@message || 'There was a server error')
  xml.error request.env['sinatra.error']
end