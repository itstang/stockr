require '../../config/initializers/twitter.rb'
require '../../config/initializers/alchemyapi'

alchemyapi = AlchemyAPI.new()

myText = "I can't wait to integrate AlchemyAPI's awesome Ruby SDK into my app!"
response = alchemyapi.sentiment("text", myText)
puts "Sentiment: " + response["docSentiment"]["type"]

tweets = $twitter.search('$' + 'XOM' + ' -rt',
                               result_type: 'mixed',
                               count: 20).take(100)

tweets.each do |tweet|
	puts tweet.text
end
