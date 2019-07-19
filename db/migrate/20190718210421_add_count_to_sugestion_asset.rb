class AddCountToSugestionAsset < ActiveRecord::Migration
  def change
    add_column :sugestion_assets, :comments_count, :integer
  end
end
