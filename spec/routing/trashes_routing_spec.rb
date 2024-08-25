require "rails_helper"

RSpec.describe TrashesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/trashes").to route_to("trashes#index")
    end

    it "routes to #new" do
      expect(get: "/trashes/new").to route_to("trashes#new")
    end

    it "routes to #show" do
      expect(get: "/trashes/1").to route_to("trashes#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/trashes/1/edit").to route_to("trashes#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/trashes").to route_to("trashes#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/trashes/1").to route_to("trashes#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/trashes/1").to route_to("trashes#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/trashes/1").to route_to("trashes#destroy", id: "1")
    end
  end
end
