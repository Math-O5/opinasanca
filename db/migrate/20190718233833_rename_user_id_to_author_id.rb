class RenameUserIdToAuthorId < ActiveRecord::Migration
  def change
    rename_column :sugestion_assets, :user_id, :author_id
  end
end
