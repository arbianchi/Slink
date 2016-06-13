require 'sinatra/base'
require 'sinatra/json'
require 'json'
require 'pry'
require "./db/setup"
require "./lib/all"
require './slackapi'
require 'rack/cors'

class SlinkApp < Sinatra::Base
  set :logging, true
  set :show_exceptions, false
  error do |e|
    raise e
  end

  use Rack::Cors do
    allow do
      origins "*"
      resource "*", headers: :any, methods: :any
    end
  end

  def SlinkApp.reset_database
    [Recommendation, Link, User].each { |klass| klass.delete_all }
  end

  #Authorization
  def username
    username = request.env["HTTP_AUTHORIZATION"]
    if !username
      status 401
      halt({ error: "You must log in" }.to_json)
    elsif User.find_by(username: username)
      username
    else
      User.create!(username: username)
      username
    end
  end

  def parsed_body
    begin
      @parsed_body ||= JSON.parse request.body.read
    rescue
      halt 400
    end
  end

  # To get list of saved bookmarks:
  get "/link" do
    links = Link.where(created_by: username)
    status 200
    json links
  end

  # To save a bookmark:
  post "/link" do
    begin
      new_link = parsed_body
      Link.create!(title: new_link["title"], description: new_link["description"], URL: new_link["URL"], created_by: username)
    rescue
      status 400
      halt "Can't parse json: '#{body}'"
    end
    200
  end

  #To get list of recommended bookmarks:
  get "/link/recommendation" do
    recommendations = Recommendation.all
    status 200
    json recommendations
  end

   #post recommendation
   post "/link/recommendation" do
 ​
     begin
       rec = parsed_body
 ​
       url = Link.where(title: rec["title"]).first["URL"]
       Recommendation.create!(title: rec["title"], posted_at: rec["posted_at"], created_by: username)
     rescue
       status 404
       halt "There is not a link titled #{rec['title']}"
     end
     200
     rec = "@#{username} recommends #{url} for @#{rec["posted_at"]}!"
     post_to_slack rec
   end

  #To delete bookmark
  delete "/link" do
    if username
      delete_link = parsed_body
      item = Link.where(title: delete_link["title"], created_by: username).first.delete
      status 200
    elsif Link.where(title: delete_link["title"])
      status 403
      halt "You can't delete that"
    else
      status 400
      halt "This doesn't exsist"
    end
  end
end


# SlinkApp.run!
