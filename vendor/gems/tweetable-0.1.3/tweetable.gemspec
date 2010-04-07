# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tweetable}
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter T. Brown"]
  s.date = %q{2010-01-25}
  s.description = %q{Tweetable is a library that makes consuming twitter data fast and easy. Tweetable supports both the old-style polling based Twitter API, and the new streaming API. You simply tell Tweetable what people or keywords you want to track, and it will take care of grabbing all the relevant data including information on users, their friends, and their messages. Redis + Ohm is used to send everything to memory for fast fast storage and lookup, and provide occasional background spooling to disk for longer-term persistence.}
  s.email = ["peter@flippyhead.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "lib/tweetable.rb", "lib/tweetable/authorization.rb", "lib/tweetable/collection.rb", "lib/tweetable/link.rb", "lib/tweetable/message.rb", "lib/tweetable/persistable.rb", "lib/tweetable/photo.rb", "lib/tweetable/queue.rb", "lib/tweetable/search.rb", "lib/tweetable/twitter_client.rb", "lib/tweetable/twitter_streaming_client.rb", "lib/tweetable/url.rb", "lib/tweetable/user.rb", "script/console", "script/destroy", "script/generate", "spec/collection_spec.rb", "spec/link_spec.rb", "spec/message_spec.rb", "spec/persistable_spec.rb", "spec/queue_spec.rb", "spec/search_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/twitter_client_spec.rb", "spec/twitter_streaming_client_spec.rb", "spec/user_spec.rb"]
  s.homepage = "http://github.com/flippyhead/linked_in"
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{tweetable}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Tweetable is a library that makes consuming twitter data fast and easy}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
