class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.references :product, index: true
      t.references :user, index: true
      t.boolean :closed, default: false
      t.boolean :done, default: false

      t.timestamps
    end
  end
end
