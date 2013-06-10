require 'spec_helper'

describe "graphs/new" do
  before(:each) do
    assign(:graph, stub_model(Graph,
      :path => "MyString",
    ).as_new_record)
  end

  it "renders new graph form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", graphs_path, "post" do
      assert_select "input#graph_path[path=?]", "graph[path]"
    end
  end
end
