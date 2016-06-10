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
    User.create! username: "tiy"
  end

  def make_link
    Link.create! username: "tiy", title: "facebook", description: "things", URL: "www.facebook.com"
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

  def test_users_cant_delete_others_links
    user = make_existing_user
    link = make_link
    header "Authorization", user.username

    r = delete "/link", {title: "notthere"}

    assert_equal 403, r.status
    assert_equal 1, Link.count
  end

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

# ["title"]
end
