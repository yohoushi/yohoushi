require 'spec_helper'

describe "debug/graphs/show" do
  before(:each) do
    @graph = assign(:graph, stub_model(Graph,
      :path => "Path",
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Path/)
  end
end
