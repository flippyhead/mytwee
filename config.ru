require 'rubygems'
require "bundler"
Bundler.setup

require 'sinatra'
 
Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production,
  :raise_errors => true
)
 
log = File.new("sinatra.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)
 
require 'application'
run Sinatra::Application