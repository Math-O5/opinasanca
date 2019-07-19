class AddNameToSugestionAssets < ActiveRecord::Migration
  def change
    add_column :sugestion_assets, :display_name, :string
  end
end
