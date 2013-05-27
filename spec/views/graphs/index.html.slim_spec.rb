require 'spec_helper'

describe "graphs/index" do
  before(:each) do
    assign(:graphs, [
      stub_model(Graph,
        :path => "Path",
      ),
      stub_model(Graph,
        :path => "Path",
      )
    ])
  end

  it "renders a list of graphs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Path".to_s, :count => 2
  end
end
