require 'json'
require 'pry'
require 'httparty'

def post_to_slack rec
	token = ENV["SLACK_API_KEY"]
	s = HTTParty.post("https://slack.com/api/chat.postMessage?token=#{token}&channel=C1FJJ2W1F&text=#{rec}&username=Slink&as_user=false&icon_url=http%3A%2F%2Fwww.toysrus.com%2Fgraphics%2Ftru_prod_images%2FSlinky--pTRU1-3025574dt.gif&pretty=1")
	return s["ok"]
end
#for testing
#post_to_slack "adina","www.test.com","maryhowell"
#puts "success!"
