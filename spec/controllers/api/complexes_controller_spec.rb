require 'spec_helper'

describe Api::ComplexesController do
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # complexesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "before create" do
    include_context "setup_graph"
    include_context "let_complex"
    include_context "stub_create_complex" if ENV['MOCK'] == 'on'
    include_context "stub_delete_complex" if ENV['MOCK'] == 'on'

    describe "POST create" do
      describe "with valid params" do
        it "creates a new complex" do
          mfclient.delete_complex(to_complex['path']) rescue nil
          post :create, {:format => 'json'}.merge(to_complex).merge({'data'=>from_graphs}), valid_session
          mfclient.delete_complex(to_complex['path']) rescue nil
          expect(response).to be_success
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested complex" do
        post :create, {:format => 'json'}.merge(to_complex).merge({'data'=>from_graphs}), valid_session
        delete :destroy, {:path => to_complex["path"], :format => 'json'}, valid_session
        expect(response).to be_success
      end
    end
  end

  describe "after create" do
    include_context "setup_complex"

    describe "GET index" do
      include_context "stub_list_complex" if ENV['MOCK'] == 'on'
      let(:complexes) { mfclient.list_complex }
      it "assigns all complexes as @complexes" do
        get :index, {:format => 'json'}, valid_session
        expect(assigns(:complexes)).to eq(complexes)
      end
    end

    describe "GET show" do
      include_context "stub_get_complex" if ENV['MOCK'] == 'on'
      let(:complex) { mfclient.get_complex(to_complex["path"]) }
      it "assigns the requested complex as @complex" do
        get :show, {:path => to_complex["path"], :format => 'json'}, valid_session
        expect(assigns(:complex)).to eq(complex)
      end
    end
  end
end
