require "spec_helper"

describe Api::Yohoushi::GraphsController do
  describe "routing" do

    it "routes to #index" do
      get("/api/yohoushi/graphs").should route_to("api/yohoushi/graphs#index", :format => "json")
    end

    it "routes to #show" do
      get("/api/yohoushi/graphs/path/to/graph").should route_to("api/yohoushi/graphs#show", :path => "path/to/graph", :format => "json")
    end

    it "routes to #update" do
      put("/api/yohoushi/graphs/path/to/graph").should route_to("api/yohoushi/graphs#update", :path => "path/to/graph", :format => "json")
    end

  end
end
