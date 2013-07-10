require "spec_helper"

describe Debug::GraphsController do
  describe "routing" do

    it "routes to #index" do
      get("/graphs").should route_to("debug/graphs#index")
    end

    it "routes to #new" do
      get("/graphs/new").should route_to("debug/graphs#new")
    end

    it "routes to #show" do
      get("/graphs/1").should route_to("debug/graphs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/graphs/1/edit").should route_to("debug/graphs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/graphs").should route_to("debug/graphs#create")
    end

    it "routes to #update" do
      put("/graphs/1").should route_to("debug/graphs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/graphs/1").should route_to("debug/graphs#destroy", :id => "1")
    end

  end
end
