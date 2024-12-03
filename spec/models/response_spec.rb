require 'rails_helper'

RSpec.describe Response do

  before do

    allow(Case).to receive(:find).and_return(kase)

    allow(Persona).to receive(:find_or_create_by).and_return(persona)
    allow(Persona).to receive(:find_or_initialize_by).and_return(persona)
    allow(persona).to receive(:codes).and_return([])
    allow(persona).to receive(:identities).and_return([])

    allow(Identity).to receive(:find_or_create_by).and_return(identity)
    allow(Identity).to receive(:reap_orphans)

    allow(Code).to receive(:find_or_create_by).and_return(code)
    allow(Code).to receive(:reap_orphans)


    allow(response_1).to receive(:question).and_return(question_1)
    allow(response_2).to receive(:question).and_return(question_2)

    allow(response_1).to receive(:case).and_return(Case.new(id: 1))
    allow(response_2).to receive(:case).and_return(Case.new(id: 1))

    allow(question_1).to receive(:context).and_return(context)
    allow(question_2).to receive(:context).and_return(context)

    allow(code).to receive(:valid?).and_return(true)
    allow(identity).to receive(:valid?).and_return(true)

  end

  let(:code) 						{ Code.new(name: "not okay", context: "age") }
  let(:context) 				{ Context.new(name: "age") }
  let(:identity) 				{ Identity.new(name: "genx", context: "age") }
  let(:persona) 				{ Persona.new(case_id: 1) }
  let(:question_1) 			{ Question.new(is_identity: true) }
  let(:question_2) 			{ Question.new(is_experience: true) }
  let(:response_1) 			{ Response.new(id: 1, raw_codes: ["not okay"]) }
  let(:response_2) 			{ Response.new(id: 2, raw_codes: ["just okay"]) }
  let(:kase) { Case.new(id: 1) }

  it "creates identities" do
    allow(Response).to receive(:find).and_return(response_1)
    expect(Identity).to receive(:find_or_create_by).with(name: "not okay", context: "age").and_return(identity)
    response_1.sync_to_graph
  end

  it "creates codes" do
    allow(Response).to receive(:find).and_return(response_2)
    expect(Code).to receive(:find_or_create_by).with(name: "just okay", context: "age"). and_return(code)
    response_2.sync_to_graph
  end

end
