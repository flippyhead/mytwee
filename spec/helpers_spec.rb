require File.dirname(__FILE__) + '/spec_helper'

class HelpersInstance
  include Helpers
end

describe Helpers do  
  before do
    RedisSpecHelper.reset
    @helpers = HelpersInstance.new
    @user = User.create(:screen_name => 'screen_name', :user_id => '123')
  end
  
  context 'when storing tidbits on a user' do
    before do
      @tidbit = Tidbit.create(:user => @user, :name => 'name', :value => 'value')#mock(Tidbit, :name => 'name', :id => 1)
    end
    
    context 'if tidbits is empty' do      
      it 'should create new tidbit' do
        @user.stub_chain(:tidbits, :find => [])
        Tidbit.should_receive(:create).with(:value => 'value', :name => 'name', :updated_at => Time.now.to_s, :user => @user).and_return(@tidbit)
        @tidbit.stub!(:valid? => true)
        @helpers.store_tidbit(@user, {'value' => 'value', 'name' => 'name'})
      end
    end
    
    context 'if tidbits exist' do      
      it "should raise error if invalid" do        
        @tidbit.stub!(:update => true, :valid? => false, :errors => 'errors', :value => 'value', :user_id => 123)
        @user.stub_chain(:tidbits, :find => [@tidbit])
        lambda{@helpers.store_tidbit(@user, {'value' => 'value', 'name' => 'name'})}.should raise_exception(Helpers::DataInvalidError)
      end
      
      it "should not try to create new tidbit" do        
        @tidbit.stub!(:update => true, :valid? => true)
        @user.stub_chain(:tidbits, :find => [@tidbit])
        Tidbit.should_receive(:create).never
        @helpers.store_tidbit(@user, {'value' => 'value', 'name' => 'name'})
      end
      
      it "should modify value of existing tidbit" do        
        @user.stub_chain(:tidbits, :find => [@tidbit])
        @tidbit.should_receive(:update).with(hash_including(:value=>"value"))
        @tidbit.stub!(:valid? => true)
        @helpers.store_tidbit(@user, {'value' => 'value', 'name' => 'name'})
      end
    end
  end
end