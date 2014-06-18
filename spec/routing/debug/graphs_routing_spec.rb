require "spec_helper"

describe Debug::GraphsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/graphs")).to route_to("debug/graphs#index")
    end

    it "routes to #new" do
      expect(get("/graphs/new")).to route_to("debug/graphs#new")
    end

    it "routes to #show" do
      expect(get("/graphs/1")).to route_to("debug/graphs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/graphs/1/edit")).to route_to("debug/graphs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/graphs")).to route_to("debug/graphs#create")
    end

    it "routes to #update" do
      expect(put("/graphs/1")).to route_to("debug/graphs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/graphs/1")).to route_to("debug/graphs#destroy", :id => "1")
    end

  end
end
