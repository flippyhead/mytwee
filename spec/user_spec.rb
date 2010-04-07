require File.dirname(__FILE__) + '/spec_helper'

describe User do
  before do
    RedisSpecHelper.reset
    @user = User.new
  end
  
  context 'setting up' do
    before do
      
    end
  end  
end