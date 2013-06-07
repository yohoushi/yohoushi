require 'spec_helper'

describe Api::GraphsController do
  include_context "setup_graph"
  include_context "stub_list_graph" if ENV['MOCK'] == 'on'
  include_context "stub_get_graph" if ENV['MOCK'] == 'on'
  let(:graphs) { mgclient.list_graph }
  let(:graph)  { graphs.first }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # GraphsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all graphs as @graphs" do
      get :index, {:format => 'json'}, valid_session
      assigns(:graphs).should eq(graphs)
    end
  end

  describe "GET show" do
    it "assigns the requested graph as @graph" do
      get :show, {:fullpath => graph["fullpath"], :format => 'json'}, valid_session
      expected = mgclient.get_graph(graph['fullpath'])
      assigns(:graph).should eq(expected)
    end
  end

  describe "POST create" do
    include_context "stub_post_graph" if ENV['MOCK'] == 'on'
    include_context "stub_delete_graph" if ENV['MOCK'] == 'on'
    let(:graph) { { 'fullpath' => "app fullpath/host fullpath/create:test" } }

    describe "with valid params" do
      it "creates a new Graph" do
        post :create, {:fullpath => graph["fullpath"], :number => 0, :format => 'json'}, valid_session
        response.should be_success
        mgclient.delete_graph(graph['fullpath'])
      end
    end
  end

  describe "DELETE destroy" do
    include_context "stub_post_graph" if ENV['MOCK'] == 'on'
    include_context "stub_delete_graph" if ENV['MOCK'] == 'on'
    let(:graph) { { 'fullpath' => "app fullpath/host fullpath/delete:test" } }

    it "destroys the requested graph" do
      post :create, {:fullpath => graph["fullpath"], :number => 0, :format => 'json'}, valid_session
      delete :destroy, {:fullpath => graph["fullpath"], :format => 'json'}, valid_session
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
        put :update, {:fullpath => graph['fullpath'], :format => 'json'}.merge(params), valid_session
        assigns(:graph).should eq({'error'=>0})
      end
    end
  end
end
