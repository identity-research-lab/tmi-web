require 'rails_helper'

RSpec.describe Services::ExportToGraph do

	before do
		allow(Response).to receive(:find).and_return(response)
		allow(Persona).to receive(:find_or_initialize_by).and_return(persona)
		allow(Persona).to receive(:create).and_return(persona)
		allow(persona).to receive(:destroy)
		allow(IdentifiesWith).to receive(:create)
	end

	let(:service) 	{ Services::ExportToGraph.new(1) }

	let(:code) 			{ Code.new(name: "not okay", context: "age") }
	let(:identity) 	{ Identity.new(name: "genx", context: "age") }

	let(:response) {
		Response.new(
			id: 1,
			raw_codes: ["not okay"]
		)
	}

	let(:persona) {
		Persona.new(
			survey_response_id: 1
		)
	}

	# TODO rewrite this entire spec
	xit 'populates experience and identity codes' do
		expect(Code).to receive(:find_or_create_by).with(name: "not okay", context: "age")
		expect(Identity).to receive(:find_or_create_by).with(name: "genx", context: "age")
		service.perform
	end

end
