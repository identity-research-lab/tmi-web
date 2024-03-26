class ForceCreateIdentityUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :Identity, :uuid, force: true
  end

  def down
    drop_constraint :Identity, :uuid
  end
end
