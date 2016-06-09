require 'sinatra/base'
require 'sinatra/json'
require 'json'
require 'pry'
require 'slackapi.rb'


class SlinkApp < Sinatra::Base
  set :logging, true
  set :show_exceptions, false
  error do |e|
    raise e
  end
  #Authorization
  before do
    require_authorization!
  end

  def require_authorization!
    username = true
    unless username
      status 401
      halt({ error: "You must log in" }.to_json)
    end
  end

  def username
    request.env["HTTP_AUTHORIZATION"]
  end

  # To get list of saved bookmarks:
  get "/link" do user
    links = Link.where(username: [header]).pluck(:user_id)
    status 200
    json links
  end

  # To save a bookmark:
  post "/link" do
    username = params[:username]
    body = request.body.read
    begin
      new_link = parsed_body
      Link.create(title: new_link[:title], description: new_link[:description], URL: new_link[:URL], created_by: user)
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

  def user
    User.where(password: request.env["HTTP_AUTHORIZATION"]).first
  end

  # Save a recommendation a bookmark:
  post "link/recommendation" do
    username = params[:username]
    body = request.body.read
    begin
      new_rec = parsed_body
      post_to_slack user, url, recipient
      Recommendation.create(title: new_rec[:title], created_by: user)
    rescue
      status 400
      halt "There is not a link titled '#{body}''"
    end
    200
  end

  #To delete bookmark
  delete "/link" do
    username = username
    body = request.body.read
    begin
      #FIXME
      item = links.find(title: title])
      status 200
    rescue
      status 400
      halt "You can't delete that"
    end

    def parsed_body
      begin
        @parsed_body ||= JSON.parse request.body.read
      rescue
        halt 400
      end
    end


  end
