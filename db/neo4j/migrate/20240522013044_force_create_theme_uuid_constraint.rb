class ForceCreateThemeUuidConstraint < ActiveGraph::Migrations::Base
  def up
#    add_constraint :Theme, :uuid, force: true
  end

  def down
#    drop_constraint :Theme, :uuid
  end
end
