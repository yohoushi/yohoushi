require "spec_helper"

describe Api::ComplexesController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/api/complexes")).to route_to("api/complexes#index", :format => "json")
    end

    it "routes to #show" do
      expect(get("/api/complexes/1")).to route_to("api/complexes#show", :path => "1", :format => "json")
    end

    it "routes to #create" do
      expect(post("/api/complexes/1")).to route_to("api/complexes#create", :path => "1", :format => "json")
    end

    it "routes to #update" do
      expect(put("/api/complexes/1")).to route_to("api/complexes#update", :path => "1", :format => "json")
    end

    it "routes to #destroy" do
      expect(delete("/api/complexes/1")).to route_to("api/complexes#destroy", :path => "1", :format => "json")
    end

  end
end
