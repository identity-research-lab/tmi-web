require 'rails_helper'

RSpec.describe ExportToGraph do

	before do
		allow(SurveyResponse).to receive(:find).and_return(survey_response)
		allow(Persona).to receive(:find_or_initialize_by).and_return(persona)
		allow(Persona).to receive(:create).and_return(persona)
		allow(persona).to receive(:destroy)
	end

	let(:survey_response) {
		SurveyResponse.new(
			id: 1,
			response_id: 1,
			age_exp_codes: ["not okay"],
			age_id_codes: ["genx"]
		)
	}

	let(:persona) {
		Persona.new(
			survey_response_id: 1
		)
	}
	let(:service) {
		ExportToGraph.new(1)
	}

	it 'assigns its SurveyResponse' do
		expect(service.survey_response.id).to eq(1)
	end

	context "populates its codes" do

		it 'finds or creates an associated code' do
			allow(Identity).to receive(:find_or_create_by)
			allow(IdentifiesWith).to receive(:create)

			expect(Code).to receive(:find_or_create_by).with(name: "not okay", context: "age").and_return(Code.new)
			expect(Experiences).to receive(:create).and_return(Experiences.new)

			service.perform
		end

		it 'finds or creates an associated identity' do
			allow(Code).to receive(:find_or_create_by)
			allow(Experiences).to receive(:create)

			expect(Identity).to receive(:find_or_create_by).with(name: "genx", context: "age").and_return(Identity.new)
			expect(IdentifiesWith).to receive(:create).and_return(IdentifiesWith.new)
			service.perform
		end

	end

end
