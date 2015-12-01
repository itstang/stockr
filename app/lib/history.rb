require 'yahoo-finance'
require 'gruff'

yahoo_client = YahooFinance::Client.new
historical_data = yahoo_client.historical_quotes("AAPL", { start_date: Time::now-(24*60*60*21), end_date: Time::now })

graph = Gruff::Line.new(600)
graph.title = 'Three Week History of AAPL'

x_axis = []

# historical_data.each do |date_data| 
# 	x_axis << date_data['trade_date']
# end

historical_data.each { |row|  x_axis << row['trade_date'] }
start_date = x_axis.min
middle_date = x_axis[(x_axis.length ) / 2]
end_date = x_axis.max

graph.labels = { 0 => start_date, 7 => middle_date, 14 => end_date }

open_history = Array.new
close_history = Array.new
high_history = Array.new
low_history = Array.new

historical_data.each do |date_data| 
	open_history.push(date_data['open'].to_f)
	close_history.push(date_data['close'].to_f)
	high_history.push(date_data['high'].to_f)
	low_history.push(date_data['low'].to_f)
end

graph.data('Open', open_history, '#B75582')
graph.data('High', high_history, '#79C65B' )
graph.data('Low', low_history)
graph.data('Close', close_history)

graph.x_axis_label = 'Date'
graph.y_axis_label = 'Dollars'

graph.write('google_stock.png')