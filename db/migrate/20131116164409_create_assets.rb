class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :photo
      t.references :product, index: true

      t.timestamps
    end
  end
end
