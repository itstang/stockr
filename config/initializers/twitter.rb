require 'rubygems'
require 'twitter'

$twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = '4zAE4k6AqkX5csufyOd7spLYa'
  config.consumer_secret = 'EGvOUs1EYEnx2ltgGos8D0G2hT535SlY7z6wQMk7C2RVjKXIdY'
  config.access_token = '4341941832-vAHPufvAdcXwj1yv1SdCyrr2jVUjFPxeGp4AwFM'
  config.access_token_secret = 'Rj1f6VzjoTs9EIcloF3g8lrOfvT7DOZaB920BHQTnPun6'
end

# include popular and real time response, omit retweets, 
tweets = $twitter.search('$' + 'XOM' + ' -rt',
                               result_type: 'mixed',
                               count: 20).take(100)

tweets.each do |tweet|
    puts tweet.text
  	end


