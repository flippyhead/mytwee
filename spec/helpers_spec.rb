require File.dirname(__FILE__) + '/spec_helper'

class HelpersInstance
  include Helpers
end

describe Helpers do  
  before(:all) do
    @helpers = HelpersInstance.new
    @user = mock(User)
  end
  
  context 'when storing tidbits on a user' do
    context 'if tidbits is empty' do      
      it 'should create new tidbit' do
        @user.stub_chain(:tidbits, :find => [])
        Tidbit.should_receive(:create).with(:value => 'value', :name => 'name', :updated_at => Time.now.to_s, :user => @user)
        @helpers.store_tidbit(@user, {'value' => 'value', 'name' => 'name'})
      end
    end
    
    context 'if tidbits exist' do
      before do
        @tidbit = mock(Tidbit, :name => 'name')
      end
      
      it "should not try to create new tidbit" do        
        @tidbit.stub!(:update => true)
        @user.stub_chain(:tidbits, :find => [@tidbit])
        Tidbit.should_receive(:create).never
        @helpers.store_tidbit(@user, {'value' => 'value', 'name' => 'name'})
      end
      
      it "should modify value of existing tidbit" do        
        @user.stub_chain(:tidbits, :find => [@tidbit])
        @tidbit.should_receive(:update).with(hash_including(:value=>"value"))
        @helpers.store_tidbit(@user, {'value' => 'value', 'name' => 'name'})
      end
    end
  end
end