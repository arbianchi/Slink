require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'rack/test'
require './app'

class AppTests < Minitest::Test
  include Rack::Test::Methods

  def app
    SlinkApp
  end

  def setup
    SlinkApp.reset_database
  end

  def make_existing_user
    User.create! username: "adina"
  end

  def create_link
    Link.create! created_by: "adina", title: "facebook", description: "things", URL: "www.facebook.com"
  end

  def make_link
    Link.create! created_by: "tiy", title: "facebook", description: "things", URL: "www.facebook.com"
  end

  def make_friend
  User.where(username: "mary").first_or_create!
end


#Adina -Post link & send recommendation
#Mary - Gets and Deletes

  def test_users_can_add_links
      user = make_existing_user
      header "Authorization", user.username
    assert_equal 0, Link.count

    r = post "/link", {title: "snapchat", description: "New Hotness", URL: "snapchat.com"}.to_json

    assert_equal 200, r.status
    assert_equal 1, Link.count
    assert_equal "New Hotness", Link.first.description
  end

  def test_users_cant_delete_arbitrary_links
    user = make_existing_user
    link = make_link
    header "Authorization", user.username

    r = delete "/link", {title: "notthere"}

    assert_equal 400, r.status
    assert_equal 1, Link.count
  end

  # def test_users_cant_delete_others_links
  #   user = make_existing_user
  #   link = make_link
  #   header "Authorization", user.username
  #
  #   r = delete "/link", {title: "notthere"}
  #
  #   assert_equal 403, r.status
  #   assert_equal 1, Link.count
  # end

  def test_users_can_delete_their_links
    user = make_existing_user
    link = make_link
    header "Authorization", user.username

    link.created_by = user.username
    link.save!
    user.save!
    r = delete "/link", {title: link.title}.to_json

    assert_equal 200, r.status
    assert_equal 0, Link.count
  end

def test_user_can_get_list_of_links
  user = make_existing_user
  header "Authorization", user.username
  t = post "/link", {title: "snapchat", description: "New Hotness", URL: "snapchat.com"}.to_json
  q = post "/link", {title: "linkedin", description: "Something", URL: "linkedin.com"}.to_json

  r = get "/link"
  assert_equal 200, r.status
  assert_equal 2, Link.count
end

def test_no_username_will_error
  r = post "/link", {title: "snapchat", description: "New Hotness", URL: "snapchat.com"}.to_json

  assert_equal 401, r.status
end

def test_wrong_username_will_error
  header "Authorization", "johnnybgood"

  r = post "/link", {title: "snapchat", description: "New Hotness", URL: "snapchat.com"}.to_json

  assert_equal 403, r.status
end

def test_missing_params_will_error
  user = make_existing_user
  header "Authorization", user.username

  r = post "/link", {title: "", description: "New Hotness", URL: "snapchat.com"}.to_json
  # q = post "link/recommendation", {title: "snapchat", description: "", URL: "snapchat.com"}.to_json

  # assert_equal 400, q.status
  assert_equal 400, r.status
end


def test_users_can_slack_recommendations
  user = make_existing_user
  friend = make_friend
  link = create_link
  header "Authorization", user.username

  s = post "/link/recommendation", {title: "facebook",posted_at: friend.username,created_by: user.username}.to_json
  #  binding.pry
  assert_equal 200, s.status
  assert_equal 1, Recommendation.count

end

# def test_users_cannot_post_to_other_users_bookmarks
#   User.create! username: "pass"
#   User.create! username: "tests"
#   rightuser = User.where(username: "pass")
#   wronguser = User.where(username: "tests")
#   wronguser.first.Link.create!
#   assert_equal 0, rightuser.first.Link.count
#   assert_equal 1, wronguser.first.Link.count
# end

# def test_user_can_recommend_to_another_user
#   header "Authorization", user.username
#   assert_equal 0, Link.count
#
#   r = post "links/recommended", body = trial_body_recom
#
#   assert_equal 200, r.status
#   assert_equal 1, Link.count
#   assert_equal user.id, Link.first.recommended_by_id
#   assert_equal friend.id, Link.first.user_id
#
# end


end
