class CreateDimensionAndNameIndexes < ActiveGraph::Migrations::Base

  def up
    add_index :Category, :dimension
    add_index :Code, :dimension
    add_index :Identity, :dimension
  end

  def down
    drop_index :Category, :dimension
    drop_index :Code, :dimension
    drop_index :Identity, :dimension
  end

end
