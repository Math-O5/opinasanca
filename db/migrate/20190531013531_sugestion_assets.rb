class SugestionAssets < ActiveRecord::Migration
  def change 
    create_table :sugestion_assets do |t|
    t.string      :title
    t.text        :description
    t.decimal     :latitude
    t.decimal     :longitude
    t.integer     :user_id
    t.boolean     :visible

    t.timestamps null: false
    end
  end
end
