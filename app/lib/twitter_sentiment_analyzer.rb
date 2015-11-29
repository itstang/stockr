require '../../config/initializers/twitter.rb'
require '../../config/initializers/alchemyapi'

alchemyapi = AlchemyAPI.new()

# myText = "I can't wait to integrate AlchemyAPI's awesome Ruby SDK into my app!"
# response = alchemyapi.sentiment("text", myText)
# puts "Sentiment Score: " + response["docSentiment"]["score"] + " Sentiment type: " + response["docSentiment"]["type"]

tweets = $twitter.search('$' + 'AAPL' + ' -rt',
                               result_type: 'mixed',
                               count: 20).take(100)

tweets.uniq
new_tweets_arr = Array.new
tweets.each do |tweet|	
	tweet_no_url= tweet.text.dup
	tweet_no_url.gsub!(/(?:f|ht)tps?:\/[^\s]+/, '')
	new_tweets_arr.push(tweet_no_url)
end

# remove duplicates
new_tweets_arr.uniq!
new_tweets_arr.each do |tweet|	
	tweet_sentiment= alchemyapi.sentiment("text", tweet)
	puts tweet
	if tweet_sentiment["status"] == 'OK'
		puts "Sentiment Score: " + tweet_sentiment["docSentiment"]["score"] + " Sentiment type: " + tweet_sentiment["docSentiment"]["type"]
	end
end
