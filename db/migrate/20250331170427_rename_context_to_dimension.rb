class RenameContextToDimension < ActiveRecord::Migration[7.2]
  def change
    rename_table :contexts, :dimensions
  end
end
