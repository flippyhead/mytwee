require 'rubygems'
require 'sinatra'
 
set :env, :production
set :raise_errors, true
disable :run
 
log = File.new("sinatra.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)
 
require 'application'
run Sinatra::Application
