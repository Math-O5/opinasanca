class AddIdToMapLocation < ActiveRecord::Migration
  def change
    add_column :map_locations, :sugestion_asset_id, :integer
  end
end
