require 'json'
require 'pry'
require 'httparty'

def post_to_slack user, url, recipient
	token = ENV["SLACK_API_KEY"]
	s = HTTParty.get("https://slack.com/api/chat.postMessage?token=#{token}&channel=%23plock_recommendations&text=#{url}%20%40#{recipient}&link_names=https%3A%2F%2Fslack.com%2F&unfurl_links=true&username=%40#{user}&as_user=true&pretty=1")
	return s["ok"]
end

#for testing
#post_to_slack "adina","www.test.com","maryhowell"
#puts "success!"
