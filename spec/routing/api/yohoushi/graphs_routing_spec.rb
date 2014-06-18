require "spec_helper"

describe Api::Yohoushi::GraphsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/api/yohoushi/graphs")).to route_to("api/yohoushi/graphs#index", :format => "json")
    end

    it "routes to #show" do
      expect(get("/api/yohoushi/graphs/path/to/graph")).to route_to("api/yohoushi/graphs#show", :path => "path/to/graph", :format => "json")
    end

    it "routes to #update" do
      expect(put("/api/yohoushi/graphs/path/to/graph")).to route_to("api/yohoushi/graphs#update", :path => "path/to/graph", :format => "json")
    end

  end
end
