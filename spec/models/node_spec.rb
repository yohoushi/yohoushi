require 'spec_helper'

describe Node do
  describe "#create_ancestors" do
    let(:path) { 'a/b/c' }
    let(:parent_id) { Node.create_ancestors(path) }
    let(:parent) { Node.find(parent_id) }
    it { parent.path.should == 'a/b' }
    it { parent.parent.path.should == 'a' }
  end

  describe "#find_or_create" do
    let(:path) { 'a/b/c' }
    subject { Node.find_or_create(path: path) }
    it { subject.path.should == 'a/b/c' }
    it { subject.parent.path.should == 'a/b' }
    it { subject.parent.parent.path.should == 'a' }
  end
end
