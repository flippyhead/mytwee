#!/usr/bin/env ruby
irb = RUBY_PLATFORM =~ /(:?mswin|mingw)/ ? 'irb.bat' : 'irb'

libs =  " -r irb/completion"
libs << " -r console_app"
libs << " -r rubygems"
libs << " -r ohm"
libs << " -r tweetable"
libs << " -r lib/user"
libs << " -r lib/tidbit"

# Ohm.connect(:db => 2)

exec "#{irb} #{libs} --simple-prompt"