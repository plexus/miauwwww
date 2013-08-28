$LOAD_PATH.unshift '/home/arne/github/twitter/lib'
require 'twitter'
require 'yaml'

module Miauwwww
  class CLI
    def self.run(*args)
      @settings = YAML.load(File.read(File.join(ENV['HOME'], '.miauwwww')))

      tweet = if args.count < 3
                $stdin.each_line.to_a.first
              else
                (args[2..-1].join(' '))
              end

      @client = Miauwwww::Client.new(
        @settings['consumer_key'],
        @settings['consumer_secret'],
        @settings['users'][args[1]]['oauth_token'],
        @settings['users'][args[1]]['oauth_token_secret']
      ).send(args[0], tweet)
    end

  end

  class Client
    def initialize(consumer_key, consumer_secret, oauth_token, oauth_token_secret)
      @twitter = Twitter::REST::Client.new do |config|
        config.consumer_key       = consumer_key
        config.consumer_secret    = consumer_secret
        config.oauth_token        = oauth_token
        config.oauth_token_secret = oauth_token_secret
      end
    end

    def tweet(text)
      @twitter.update(text)
    end

    def count(text)
      puts text.length
    end
  end
end
