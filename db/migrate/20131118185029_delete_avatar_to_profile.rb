class DeleteAvatarToProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :avatar, :string
  end
end
