class CreateDimensionAndNameIndexes < ActiveGraph::Migrations::Base

  def up
    add_index :Category, :dimension
    add_index :Category, :name
    add_index :Code, :dimension
    add_index :Code, :name
    add_index :Identity, :dimension
    add_index :Identity, :name
    add_index :Theme, :name
  end

  def down
    drop_index :Category, :dimension
    drop_index :Category, :name
    drop_index :Code, :dimension
    drop_index :Code, :name
    drop_index :Identity, :dimension
    drop_index :Identity, :name
    drop_index :Theme, :name
  end

end
