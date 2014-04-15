class AddSatisfiedToStatus < ActiveRecord::Migration
  def change
    add_column :statuses, :satisfied, :boolean
  end
end
