require '../../config/initializers/twitter.rb'
require '../../config/initializers/alchemyapi'

alchemyapi = AlchemyAPI.new()
num_tweets=0
total_score=0
avg_sentiment= 0
new_tweets_arr = Array.new

# due to alchemy api limitations, we are only using four tweets for now
tweets = $twitter.search('$' + 'ACOR' + ' -rt',
                               result_type: 'mixed',
                               count: 20).take(4)

# remove url from tweets
tweets.each do |tweet|	
	tweet_no_url= tweet.text.dup
	tweet_no_url.gsub!(/(?:f|ht)tps?:\/[^\s]+/, '')
	new_tweets_arr.push(tweet_no_url)
end

# remove duplicates
new_tweets_arr.uniq!
new_tweets_arr.each do |tweet|	
	tweet_sentiment= alchemyapi.sentiment("text", tweet)
	if tweet_sentiment["status"] == 'OK' && tweet_sentiment["docSentiment"]["score"] != nil
		total_score += tweet_sentiment["docSentiment"]["score"].to_f
		num_tweets= num_tweets + 1
	end
end

avg_sentiment = total_score/num_tweets
# For testing purposes
# puts avg_sentiment
# puts num_tweets
