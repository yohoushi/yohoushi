require "spec_helper"

describe Api::ComplexesController do
  describe "routing" do

    it "routes to #index" do
      get("/api/complexes").should route_to("api/complexes#index", :format => "json")
    end

    it "routes to #show" do
      get("/api/complexes/1").should route_to("api/complexes#show", :fullpath => "1", :format => "json")
    end

    it "routes to #create" do
      post("/api/complexes/1").should route_to("api/complexes#create", :fullpath => "1", :format => "json")
    end

    it "routes to #update" do
      put("/api/complexes/1").should route_to("api/complexes#update", :fullpath => "1", :format => "json")
    end

    it "routes to #destroy" do
      delete("/api/complexes/1").should route_to("api/complexes#destroy", :fullpath => "1", :format => "json")
    end

  end
end
