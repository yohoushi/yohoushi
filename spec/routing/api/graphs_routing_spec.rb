require "spec_helper"

describe Api::GraphsController do
  describe "routing" do

    it "routes to #index" do
      get("/api/graphs").should route_to("api/graphs#index", :format => "json")
    end

    it "routes to #show" do
      get("/api/graphs/1").should route_to("api/graphs#show", :fullpath => "1", :format => "json")
    end

    it "routes to #create" do
      post("/api/graphs/1").should route_to("api/graphs#create", :fullpath => "1", :format => "json")
    end

    it "routes to #update" do
      put("/api/graphs/1").should route_to("api/graphs#update", :fullpath => "1", :format => "json")
    end

    it "routes to #destroy" do
      delete("/api/graphs/1").should route_to("api/graphs#destroy", :fullpath => "1", :format => "json")
    end

  end
end
