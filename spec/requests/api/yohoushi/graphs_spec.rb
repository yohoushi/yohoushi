require 'spec_helper'
require 'json'

describe "/api/yohoushi/graphs" do
  let(:path) { 'path/to/graph' }
  let(:desc) { 'test' }
  let(:visible) { true }
  let(:graph) { Graph.find_or_create(path: path, description: desc, visible: visible) }
  let(:parsed_body) { JSON.parse(response.body) }

  describe "GET /api/yohoushi/graphs" do
    before do
      graph
      get api_yohoushi_graphs_path
    end
    it "Returns all graphs", autodoc: true do
      expect(response.status).to be 200
    end
    it "response must be an Array" do
      expect(parsed_body).to be_an Array
    end
    it "expected graph" do
      expect(parsed_body.first['path']).to eq graph.path
      expect(parsed_body.first['uri']).to include(graph.path)
    end
  end

  describe "GET /api/yohoushi/graphs/:path" do
    before do
      get api_yohoushi_graphs_path + '/' + graph.path
    end
    it "Returns a graph", autodoc: true do
      expect(response.status).to be 200
    end
    it "response must be a Hash" do
      expect(parsed_body).to be_a Hash
    end
    it "response has expected params" do
      expect(parsed_body['path']).to eq path
      expect(parsed_body['description']).to eq graph.description
      expect(parsed_body['tag_list']).to eq graph.tag_list
      expect(parsed_body['visible']).to eq graph.visible
    end
  end
 
  describe "PUT /api/yohoushi/graphs/path/to/graph" do
    let(:new_desc) { desc + ' update' }
    let(:new_tag_list) { "a,b,c" }
    let(:new_visible) { false }
    let(:attr) { { 'description' => new_desc, 'tag_list' => new_tag_list, 'visible' => new_visible } }
    before do
      put api_yohoushi_graphs_path + '/' + graph.path, attr
    end
    it "Updates a graph", autodoc: true do
      expect(response.status).to be 200
    end
    it "response must be a Hash" do
      expect(parsed_body).to be_a Hash
    end
    it "response has expected params" do
      expect(parsed_body['path']).to eq path
      expect(parsed_body['description']).to eq new_desc
      expect(parsed_body['tag_list']).to eq new_tag_list.split(/,/)
      expect(parsed_body['visible']).to eq new_visible
    end
  end
 
end
