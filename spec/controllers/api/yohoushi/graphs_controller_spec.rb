require 'spec_helper'
require 'json'

describe Api::Yohoushi::GraphsController do
  let(:path) { 'path/to/grap' }
  let(:description) { 'test' }
  let(:visible) { true }
  let(:graph) { Graph.find_or_create(path: path, description: description, visible: visible) }
 
  let(:valid_session) { {} }

  before do
    request.env["HTTP_ACCEPT"] = 'application/json'
    stub_request(:any, /./).to_return(:status => 200, :body => "{}", :headers => {})
    graph # create a graph
  end

  describe "GET index" do
    it "assigns all graphs as @graphs" do
      get :index, {}, valid_session
      assigns(:graphs).should eq([graph])
    end
  end

  describe "GET show" do
    it "assigns the requested graph as @graph" do
      get :show, {:path => graph.path}, valid_session
      assigns(:graph).should eq(graph)
    end
  end

  describe "PUT update" do
    context "with valid params" do
      let(:new_description) { description + ' update' }
      let(:new_tag_list) { %w(a b c) }
      let(:new_visible) { false }
      let(:attr) { { "description" => new_description, "tag_list" => new_tag_list, "visible" => new_visible } }
      it "updates the requested graph" do
        Graph.any_instance.should_receive(:update).with(attr)
        put :update, {path: graph.path}.merge(attr), valid_session
      end

      it "assigns the requested graph as @graph" do
        put :update, {:path => graph.path}, valid_session
        assigns(:graph).should eq(graph)
      end
    end

    context "Unprocessable entity" do
      before do
        Graph.any_instance.stub(:update).and_return(false)
        put :update, {path: graph.path}, valid_session
      end

      it "422 Unprocessable Entity" do
        expect(response.status).to eq 422
      end
    end
  end

end
