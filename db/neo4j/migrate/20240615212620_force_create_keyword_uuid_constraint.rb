class ForceCreateKeywordUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :Keyword, :uuid, force: true
  end

  def down
    drop_constraint :Keyword, :uuid
  end
end
