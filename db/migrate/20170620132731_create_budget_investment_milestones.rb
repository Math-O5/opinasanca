class CreateBudgetInvestmentMilestones < ActiveRecord::Migration
  def change
    create_table :budget_investment_milestones do |t|
      t.integer :investment_id
      t.string   "title", limit: 80
      t.text     "description"

      t.timestamps null: false
    end
  end
end
