require 'spec_helper'

describe "graphs/show" do
  before(:each) do
    @graph = assign(:graph, stub_model(Graph,
      :fullpath => "Path",
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Path/)
  end
end
