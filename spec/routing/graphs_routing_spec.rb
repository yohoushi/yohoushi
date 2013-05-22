require "spec_helper"

describe GraphsController do
  describe "routing" do

    it "routes to #index" do
      get("/graphs").should route_to("graphs#index", :format => "json")
    end

    it "routes to #show" do
      get("/graphs/1").should route_to("graphs#show", :path => "1", :format => "json")
    end

    it "routes to #create" do
      post("/graphs/1").should route_to("graphs#create", :path => "1", :format => "json")
    end

    it "routes to #update" do
      put("/graphs/1").should route_to("graphs#update", :path => "1", :format => "json")
    end

    it "routes to #destroy" do
      delete("/graphs/1").should route_to("graphs#destroy", :path => "1", :format => "json")
    end

  end
end
