class ForceCreateCodeUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :Code, :uuid, force: true
  end

  def down
    drop_constraint :Code, :uuid
  end
end
