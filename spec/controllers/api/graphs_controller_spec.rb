require 'spec_helper'

describe Api::GraphsController do
  include_context "setup_mgclient"
  let(:graphs) { mgclient.list_graph }
  let(:graph)  { mgclient.get_graph(graphs.first['path']) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # GraphsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    include_context "stub_list_graph" if ENV['MOCK'] == 'on'
    it "assigns all graphs as @graphs" do
      get :index, {:format => 'json'}, valid_session
      assigns(:graphs).should eq(graphs)
    end
  end

  describe "GET show" do
    include_context "stub_get_graph" if ENV['MOCK'] == 'on'
    it "assigns the requested graph as @graph" do
      get :show, {:path => graph["path"], :format => 'json'}, valid_session
      assigns(:graph).should eq(graph)
    end
  end

  describe "POST create" do
    include_context "stub_post_graph" if ENV['MOCK'] == 'on'
    include_context "stub_delete_graph" if ENV['MOCK'] == 'on'
    let(:graph) { { 'path' => "app name/host name/create:test" } }

    describe "with valid params" do
      it "creates a new Graph" do
        post :create, {:path => graph["path"], :number => 0, :format => 'json'}, valid_session
        response.should be_success
        mgclient.delete_graph(graph['path'])
      end
    end
  end

  describe "DELETE destroy" do
    include_context "stub_post_graph" if ENV['MOCK'] == 'on'
    include_context "stub_delete_graph" if ENV['MOCK'] == 'on'
    let(:graph) { { 'path' => "app name/host name/delete:test" } }

    it "destroys the requested graph" do
      post :create, {:path => graph["path"], :number => 0, :format => 'json'}, valid_session
      delete :destroy, {:path => graph["path"], :format => 'json'}, valid_session
      response.should be_success
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      include_context "stub_edit_graph" if ENV['MOCK'] == 'on'
      params = {
        'sort' => 19,
        'adjust' => '/',
        'adjustval' => '1000000',
        'unit' => 'sec',
        'color'  => "#000000"
      }
      it "assigns the requested graph as @graph" do
        put :update, {:path => graph['path'], :format => 'json'}.merge(params), valid_session
        assigns(:graph).should eq({'error'=>0})
      end
    end
  end
end
