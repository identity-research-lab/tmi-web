class ForceCreatePersonaUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :Persona, :uuid, force: true
  end

  def down
    drop_constraint :Persona, :uuid
  end
end
