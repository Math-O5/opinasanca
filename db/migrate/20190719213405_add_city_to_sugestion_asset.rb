class AddCityToSugestionAsset < ActiveRecord::Migration
  def change
    add_column :sugestion_assets, :city, :string
  end
end
