require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

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

  def make_link
    Links.create! title: "facebook", description: "things", URL: "www.facebook.com"
  end


#Adina -Post link & send recommendation
#Mary - Gets and Deletes

  def test_users_can_add_links
    user = make_existing_user
    header "Authorization", user.password
    assert_equal 0, Item.count

    r = post "/link", title: "snapchat", description: "New Hotness", URL: "snapchat.com"

    assert_equal 200, r.status
    assert_equal 1, Link.count
    assert_equal "New Hotness", Link.first.description
  end

  # def test_users_can_buy_items
  #   item = make_item
  #   user = make_existing_user
  #   header "Authorization", user.password
  #
  #   r = post "/items/#{item.id}/buy", quantity: 5
  #
  #   assert_equal 200, r.status
  #   assert_equal 1, Purchase.count
  #   assert_equal 5, Purchase.first.quantity
  #   assert_equal Purchase.first, user.purchases.first
  # end

  # def test_users_cant_buy_non_items
  #   user = make_existing_user
  #   header "Authorization", user.password
  #
  #   assert_raises ActiveRecord::RecordNotFound do
  #     post "/items/99999/buy", quantity: 5
  #   end
  #
  #   assert_equal 0, Purchase.count
  # end

  # def test_users_cant_delete_arbitrary_items
  #   item = make_item
  #   user = make_existing_user
  #   header "Authorization", user.password
  #
  #   r = delete "/items/#{item.id}"
  #
  #   assert_equal 403, r.status
  #   assert_equal 1, Item.count
  # end

  # def test_users_can_delete_their_items
  #   item = make_item
  #   user = make_existing_user
  #   header "Authorization", user.password
  #
  #   item.listed_by = user
  #   item.save!
  #   r = delete "/items/#{item.id}"
  #
  #   assert_equal 200, r.status
  #   assert_equal 0, Item.count
  # end
  #
  # def test_users_can_see_who_has_ordered_an_item
  #   item = make_item
  #   3.times do |i|
  #     u = User.create! first_name: i, last_name: i, password: "pass#{i}"
  #     u.purchases.create! item: item, quantity: 4
  #   end
  #
  #   r = get "/items/#{item.id}/purchases"
  #
  #   assert_equal 200, r.status
  #   body = JSON.parse r.body
  #   assert_equal 3, body.count
  # end
end
