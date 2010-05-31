xml.tag!('leaders') do
  xml.tag!('monthly', :count => @monthly_tidbits.size) do
    @monthly_tidbits.each do |tidbit|
      partial "user", :locals => {:user => tidbit.user, :_xml => xml}
    end
  end
  
  xml.tag!('alltime', :count => @alltime_tidbits.size) do
    @alltime_tidbits.each do |tidbit|
      partial "user", :locals => {:user => tidbit.user, :_xml => xml}
    end
  end
  
  xml.tag!('recent', :count => @recent_tidbits.size) do
    @recent_tidbits.each do |tidbit|
      xml.tag!('stuff', :updated_at => tidbit.updated_at) do
        partial "user", :locals => {:user => tidbit.user, :_xml => xml}
      end
    end
  end
end