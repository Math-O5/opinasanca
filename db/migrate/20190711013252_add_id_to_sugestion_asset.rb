class AddIdToSugestionAsset < ActiveRecord::Migration
  def change
    add_column :sugestion_assets, :sugestion_id, :integer
  end
end
