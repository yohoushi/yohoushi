require 'spec_helper'

describe "tags/show" do
  before(:each) do
    @tag = assign(:tag, stub_model(Tag,
      :tag => "Tag"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Tag/)
  end
end
