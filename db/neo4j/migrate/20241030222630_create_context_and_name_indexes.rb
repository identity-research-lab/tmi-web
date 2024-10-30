class CreateContextAndNameIndexes < ActiveGraph::Migrations::Base

  def up
    add_index :Category, :context
    add_index :Category, :name
    add_index :Code, :context
    add_index :Code, :name
    add_index :Identity, :context
    add_index :Identity, :name
    add_index :Theme, :name
  end

  def down
    remove_index :Category, :context
    remove_index :Category, :name
    remove_index :Code, :context
    remove_index :Code, :name
    remove_index :Identity, :context
    remove_index :Identity, :name
    remove_index :Theme, :name
  end

end
