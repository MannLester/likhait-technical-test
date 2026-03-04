class AddDateToExpenses < ActiveRecord::Migration[7.2]
  def up
    unless column_exists?(:expenses, :date)
      add_column :expenses, :date, :date

      execute "UPDATE expenses SET date = DATE(created_at) WHERE date IS NULL"

      change_column_null :expenses, :date, false
    end

    unless index_exists?(:expenses, :date)
      add_index :expenses, :date, name: "index_expenses_on_date"
    end

    if column_exists?(:expenses, :payer_name)
      remove_column :expenses, :payer_name
    end

    if index_exists?(:expenses, :created_at, name: "idx_created_at")
      remove_index :expenses, name: "idx_created_at"
    end
  end

  def down
    add_column :expenses, :payer_name, :string, limit: 100, null: false, default: "Unknown"
    add_index :expenses, :created_at, name: "idx_created_at"

    remove_index :expenses, name: "index_expenses_on_date" if index_exists?(:expenses, :date, name: "index_expenses_on_date")
    remove_column :expenses, :date if column_exists?(:expenses, :date)
  end
end
