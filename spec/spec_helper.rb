require File.join(File.dirname(__FILE__), '..', 'application.rb')
require 'rubygems'
require 'redis'
require 'sinatra'
require 'rack/test'
require 'spec'
require 'spec/autorun'
# require 'spec/interop/test'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

class RedisSpecHelper
  TEST_DB_ID = 15

  def reset
    Omg.redis.select_db(TEST_DB_ID)
    Omg.redis.flush_db
  end
end

