# This is a starting point. Feel free to add / modify, as long as the tests pass
class SlinkApp < Sinatra::Base
  set :logging, true
  set :show_exceptions, false
  error do |e|
    raise e
  end

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
    body links.to_json
  end

    # To save a bookmark:
  post "/link" do
    users = params[:username]
    body = request.body.read
    begin
      new_link = parsed_body
      Link.create(title: new_link[:title], description: new_link[:description], URL: new_link[:URL])
    rescue
      status 400
      halt "Can't parse json: '#{body}'"
    end
    200
  end


  #
  # Request:
  # GET "/link/recommendation" do
  # HEADER: "Authorization: username"
  #
  # Response:
  # BODY JSON [{BookmarkObject1
  #     title: "title"
  #     description: "description"
  #     url: "url"
  #     created_by: "username"
  #     posted_to: "otherusername"
  #     created_at: timestamp
  #
  #   },
  #   {BookmarkObject2
  #     title: "title"
  #     description: "description"
  #     url: "url"
  #     created_by: "username"
  #     created_at: timestamp
  #     }]
  #
  #   Status: (200, 401, 403, etc...)



  # def user
  #   User.where(password: request.env["HTTP_AUTHORIZATION"]).first
  # end

  def parsed_body
    begin
      @parsed_body ||= JSON.parse request.body.read
    rescue
      halt 400
    end
  end


end
