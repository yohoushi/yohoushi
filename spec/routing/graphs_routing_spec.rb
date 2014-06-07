require "spec_helper"

describe GraphsController do
  describe "routing" do

    it "routes to #tree_graph" do
      get("/tree_graph").should route_to("graphs#tree_graph")
    end

    it "routes to #view_graph" do
      get("/view_graph/path").should route_to("graphs#view_graph", :path => "path")
    end

    it "routes to #setup_graph" do
      get("/setup_graph/path").should route_to("graphs#setup_graph", :path => "path")
    end

    it "routes to #list_graph" do
      get("/list_graph").should route_to("graphs#list_graph")
      get("/list_graph/path").should route_to("graphs#list_graph", :path => "path")
    end

    it "routes to #tag_graph" do
      get("/tag_graph").should route_to("graphs#tag_graph")
      get("/tag_graph/tag_list").should route_to("graphs#tag_graph", :tag_list => "tag_list")
      delete("/tag_graph/tag_list").should route_to("graphs#delete_tag_graph", :tag_list => "tag_list")
    end

    it "routes to #autocomplete_graph" do
      get("/autocomplete_graph").should route_to("graphs#autocomplete_graph")
    end

    it "routes to #tagselect_graph" do
      get("/tagselect_graph").should route_to("graphs#tagselect_graph")
    end

    it "routes to #accordion_graph" do
      get("/accordion_graph").should route_to("graphs#accordion_graph")
    end

  end
end
