require "spec_helper"

describe GraphsController do
  describe "routing" do

    it "routes to #tree_graph" do
      expect(get("/tree_graph")).to route_to("graphs#tree_graph")
    end

    it "routes to #view_graph" do
      expect(get("/view_graph/path")).to route_to("graphs#view_graph", :path => "path")
    end

    it "routes to #setup_graph" do
      expect(get("/setup_graph/path")).to route_to("graphs#setup_graph", :path => "path")
    end

    it "routes to #list_graph" do
      expect(get("/list_graph")).to route_to("graphs#list_graph")
      expect(get("/list_graph/path")).to route_to("graphs#list_graph", :path => "path")
    end

    it "routes to #tag_graph" do
      expect(get("/tag_graph")).to route_to("graphs#tag_graph")
      expect(get("/tag_graph/tag_list")).to route_to("graphs#tag_graph", :tag_list => "tag_list")
      expect(delete("/tag_graph/tag_list")).to route_to("graphs#delete_tag_graph", :tag_list => "tag_list")
    end

    it "routes to #autocomplete_graph" do
      expect(get("/autocomplete_graph")).to route_to("graphs#autocomplete_graph")
    end

    it "routes to #tagselect_graph" do
      expect(get("/tagselect_graph")).to route_to("graphs#tagselect_graph")
    end

    it "routes to #accordion_graph" do
      expect(get("/accordion_graph")).to route_to("graphs#accordion_graph")
    end

  end
end
