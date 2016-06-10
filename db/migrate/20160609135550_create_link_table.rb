class CreateLinkTable < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :title
      t.string :description
      t.string :URL
      t.string :created_by
      t.timestamps :created_at
    end
  end
end
