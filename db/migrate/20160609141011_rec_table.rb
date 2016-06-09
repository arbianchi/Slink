class RecTable < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.string :title
      t.string :description
      t.string :URL
      t.integer :created_by
      t.timestamps :created_at
      t.string :posted_at
    end
  end
end
