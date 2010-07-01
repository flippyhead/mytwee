class Tidbit < Tweetable::Persistable
  attribute :created_at
  attribute :updated_at
  attribute :name
  attribute :value  
  reference :user, User
  index :name
  
  def self.search(options = {})
    name = options[:name]
    sort_by = options[:sort_by] || :value
    after = Time.now - options[:ago] if options.include?(:ago)        
    
    tidbits = Tidbit.find(:name => name).sort_by(sort_by, :order => 'DESC')
    tidbits.reject{|t| Time.parse(t.updated_at) < after} unless after.blank?
    tidbits
  end
  
  def validate
    assert_present :name
    assert_present :value
    assert_present :user
    assert_format :name, /^[^\s]+$/
    assert_unique [:user_id, :name]
  end
end
