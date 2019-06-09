class ChangePriceFieldsToBigint < ActiveRecord::Migration
  def up
    change_column :spending_proposals, :price, :bigint
    change_column :spending_proposals, :price_first_year, :bigint
  end

  def down
    change_column :spending_proposals, :price, :integer
    change_column :spending_proposals, :price_first_year, :integer
  end
end
