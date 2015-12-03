require '../../config/initializers/twitter.rb'
require '../../config/initializers/alchemyapi'

alchemyapi = AlchemyAPI.new()
num_tweets=0
total_score=0
cur_sentiment=0
avg_sentiment= 0
new_tweets_arr = Array.new
tweets_hash = Hash.new

# due to alchemy api limitations (1000 requests), we are only using four tweets for now
tweets = $twitter.search('$' + 'AAPL' + ' -rt',
                               result_type: 'mixed',
                               count: 20).take(50)

# remove url from tweets
tweets.each do |tweet|	
	tweet_no_url= tweet.text.dup
	tweet_no_url.gsub!(/(?:f|ht)tps?:\/[^\s]+/, '')
	tweets_hash[tweet_no_url]= tweet.user.verified?

end

# remove duplicates
# tweets_hash.uniq!
tweets_hash.each do |tweet,verified|	
	tweet_sentiment= alchemyapi.sentiment("text", tweet)
	if tweet_sentiment["status"] == 'OK' && tweet_sentiment["docSentiment"]["score"] != nil
		cur_sentiment= tweet_sentiment["docSentiment"]["score"].to_f
		if(verified == true)
			cur_sentiment += cur_sentiment + (cur_sentiment*0.5)
		end
		total_score += cur_sentiment
		num_tweets= num_tweets + 1
	end
end

avg_sentiment = total_score/num_tweets
# For testing purposes
puts avg_sentiment
# puts num_tweets
# 
# if negative sentiment + high stock = sell
# negative + low= don't buy, sell
# positive sentiment + low stock price= buy
# 
