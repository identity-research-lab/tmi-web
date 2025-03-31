class CreateContextAndNameIndexes < ActiveGraph::Migrations::Base

  def up
    # add_index :Category, :context
    # add_index :Category, :name
    # add_index :Code, :context
    # add_index :Code, :name
    # add_index :Identity, :context
    # add_index :Identity, :name
    # add_index :Theme, :name
  end

  def down
    drop_index :Category, :context
    drop_index :Category, :name
    drop_index :Code, :context
    drop_index :Code, :name
    drop_index :Identity, :context
    drop_index :Identity, :name
    drop_index :Theme, :name
  end

end
