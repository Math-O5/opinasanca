class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :title
      t.string :subject
      t.text :description
      t.text :response
      t.datetime :date
      t.string :where
      t.integer :priority
      t.boolean :published

      t.timestamps null: false
    end
  end
end
