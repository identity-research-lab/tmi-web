class RenameContextIndexesToDimension < ActiveRecord::Migration[7.2]
  def change
    rename_column :questions, :context_id, :dimension_id
  end
end
