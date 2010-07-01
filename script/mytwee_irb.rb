#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
require 'irb'

Bundler.setup
Bundler.require

autoload :User, File.join(File.dirname(__FILE__), *%w[.. lib user.rb])
autoload :Tidbit, File.join(File.dirname(__FILE__), *%w[.. lib tidbit.rb])

Ohm.connect(:db => 2)

IRB.start