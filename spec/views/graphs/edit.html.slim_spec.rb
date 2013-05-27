require 'spec_helper'

describe "graphs/edit" do
  before(:each) do
    @graph = assign(:graph, stub_model(Graph,
      :path => "MyString",
    ))
  end

  it "renders the edit graph form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", graph_path(@graph), "post" do
      assert_select "input#graph_path[name=?]", "graph[path]"
    end
  end
end
