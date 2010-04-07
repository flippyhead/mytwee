xml.tag!('tidbit', :id => @tidbit.id) do
  xml.name @tidbit.name
  xml.data @tidbit.value
end