require "spec_helper"

describe Api::GraphsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/api/graphs")).to route_to("api/graphs#index", :format => "json")
    end

    it "routes to #show" do
      expect(get("/api/graphs/1")).to route_to("api/graphs#show", :path => "1", :format => "json")
    end

    it "routes to #create" do
      expect(post("/api/graphs/1")).to route_to("api/graphs#create", :path => "1", :format => "json")
    end

    it "routes to #update" do
      expect(put("/api/graphs/1")).to route_to("api/graphs#update", :path => "1", :format => "json")
    end

    it "routes to #destroy" do
      expect(delete("/api/graphs/1")).to route_to("api/graphs#destroy", :path => "1", :format => "json")
    end

  end
end
